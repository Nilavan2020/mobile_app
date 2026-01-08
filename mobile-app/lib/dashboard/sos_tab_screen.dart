import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import '../services/locale_service.dart';
import '../services/location_analyzer.dart';
import '../config.dart';
import 'profile_info.dart';

class SOSTabScreen extends StatefulWidget {
  const SOSTabScreen({Key? key}) : super(key: key);

  @override
  _SOSTabScreenState createState() => _SOSTabScreenState();
}

class _SOSTabScreenState extends State<SOSTabScreen> {
  final _storage = FlutterSecureStorage();
  final _locationAnalyzer = LocationAnalyzer();
  bool _sosActive = false;
  bool _isLoading = false;
  bool _isCheckingLocation = false;
  String _emergencyContact = '';
  String _policeContact = '';
  String _userName = '';
  String _userPhone = '';
  
  // Location status
  Position? _currentPosition;
  bool? _isDangerArea;
  String _locationStatus = 'Not checked';
  String _locationDetails = '';

  @override
  void initState() {
    super.initState();
    _loadEmergencyContacts();
    // Location will be checked when SOS button is clicked
  }

  Future<void> _loadEmergencyContacts() async {
    String? userId = await _storage.read(key: 'userId');
    if (userId == null) return;

    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/user/profile/mobile?user_id=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          setState(() {
            _emergencyContact = data['data']['emergency_contact'] ?? '';
            _policeContact = data['data']['police_contact'] ?? '';
            _userName = data['data']['full_name'] ?? '';
            _userPhone = data['data']['phone_number'] ?? '';
          });
        }
      }
    } catch (e) {
      // Silently fail - contacts will show as "Not set"
    }
  }

  Future<void> _checkLocation() async {
    setState(() {
      _isCheckingLocation = true;
      _locationStatus = 'Checking location...';
    });

    try {
      // Request location permission
      // Wrap in try-catch to handle MissingPluginException gracefully
      bool serviceEnabled = false;
      try {
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      } catch (e) {
        // If plugin not ready, show helpful message
        setState(() {
          _locationStatus = 'Please restart app';
          _isCheckingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please stop and restart the app to enable location services'),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      if (!serviceEnabled) {
        setState(() {
          _locationStatus = 'Location services disabled';
          _isCheckingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enable location services')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationStatus = 'Location permission denied';
            _isCheckingLocation = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission is required')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationStatus = 'Location permission permanently denied';
          _isCheckingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enable location permission in settings')),
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      // Analyze location
      final isDanger = await _locationAnalyzer.isDangerArea(
        position.latitude,
        position.longitude,
      );

      // Get location details
      final locationDetails = await _locationAnalyzer.getLocationDetails(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _isDangerArea = isDanger;
        _locationStatus = isDanger ? 'DANGER AREA' : 'SAFE AREA';
        _locationDetails = locationDetails['display_name'] ?? 
                          '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
        _isCheckingLocation = false;
      });
    } catch (e) {
      setState(() {
        _locationStatus = 'Error: $e';
        _isCheckingLocation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  Future<void> _sendSOSAlert() async {
    String? userId = await _storage.read(key: 'userId');
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found. Please log in again.')),
      );
      setState(() {
        _sosActive = false;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Check location when SOS is activated (if not already checked) - with timeout
      if (_currentPosition == null || _isDangerArea == null) {
        // Store previous danger area status before checking
        final previousDangerArea = _isDangerArea;
        try {
          await _checkLocation().timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              // If location check times out, preserve previous value if available, otherwise default to false
              setState(() {
                _isDangerArea = previousDangerArea ?? false;
                _locationDetails = _locationDetails.isNotEmpty 
                    ? _locationDetails 
                    : 'Location check timed out';
              });
            },
          );
        } catch (e) {
          // If location check fails, preserve previous value if available, otherwise default to false
          setState(() {
            _isDangerArea = previousDangerArea ?? false;
            _locationDetails = _locationDetails.isNotEmpty 
                ? _locationDetails 
                : 'Location unavailable';
          });
        }
      }

      // Get mobile phone's current time
      final now = DateTime.now();
      final currentHour = now.hour;
      
      // Prepare alert data
      Map<String, dynamic> alertData = {
        'user_id': int.parse(userId),
        'emergency_contact': _emergencyContact,
        'police_contact': _policeContact,
        'user_name': _userName,
        'user_phone': _userPhone,
        // Send mobile phone's current time
        'mobile_time': now.toIso8601String(),
        'mobile_hour': currentHour,
      };

      // Debug print
      print('SOS Alert - Mobile Phone Time: ${now.toString()}');
      print('SOS Alert - Mobile Phone Hour: $currentHour');
      final isNightTime = (currentHour >= 18) || (currentHour <= 5);
      print('SOS Alert - Is Nighttime (>=18 OR <=5)? $isNightTime');

      // Add location data if available
      if (_currentPosition != null) {
        alertData['latitude'] = _currentPosition!.latitude;
        alertData['longitude'] = _currentPosition!.longitude;
        // Ensure boolean is sent as true/false, not string
        alertData['is_danger_area'] = _isDangerArea == true; // Force boolean conversion
        alertData['location_details'] = _locationDetails;
        
        // Debug print
        print('SOS Alert - Sending data: is_danger_area = ${alertData['is_danger_area']} (type: ${alertData['is_danger_area'].runtimeType})');
        print('SOS Alert - _isDangerArea value: $_isDangerArea (type: ${_isDangerArea.runtimeType})');
      } else {
        // If location not checked yet, set defaults
        alertData['is_danger_area'] = false;
        alertData['location_details'] = 'Location not available';
        print('SOS Alert - No location data, defaulting is_danger_area to false');
      }

      // Call backend API to send SMS with timeout
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/sos/send-alert'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(alertData),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - Server did not respond in time');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final sentCount = data['data']?['sent_count'] ?? 0;
          final alertLevel = data['data']?['alert_level'] ?? 'stage_1';
          
          String message = 'SOS Alert Sent!';
          if (alertLevel == 'stage_2') {
            message = 'SOS Alert Sent! Emergency contact and police notified (Stage 2 - Serious).';
          } else {
            message = 'SOS Alert Sent! Emergency contact notified (Stage 1).';
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
            ),
          );
        } else {
          // Show detailed error message from backend
          String errorMsg = data['message'] ?? 'Failed to send SOS alert';
          if (data['data']?['error_details'] != null) {
            final errorDetails = data['data']['error_details'];
            if (errorDetails is List && errorDetails.isNotEmpty) {
              errorMsg = errorDetails[0]['message'] ?? errorMsg;
            }
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
          setState(() {
            _sosActive = false;
          });
        }
      } else {
        // Handle non-200 status codes
        String errorMsg = 'Failed to send SOS alert';
        try {
          final errorData = json.decode(response.body);
          errorMsg = errorData['message'] ?? errorMsg;
          if (errorData['data']?['error_details'] != null) {
            final errorDetails = errorData['data']['error_details'];
            if (errorDetails is List && errorDetails.isNotEmpty) {
              errorMsg = errorDetails[0]['message'] ?? errorMsg;
            }
          }
        } catch (e) {
          errorMsg = 'Server error (Status: ${response.statusCode})';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
        setState(() {
          _sosActive = false;
        });
      }
    } catch (e) {
      String errorMessage = 'Error sending SOS alert';
      if (e.toString().contains('timeout')) {
        errorMessage = 'Request timeout. Please check your internet connection and try again.';
      } else if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        errorMessage = 'Cannot connect to server. Please check your internet connection.';
      } else {
        errorMessage = 'Error: ${e.toString()}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
      setState(() {
        _sosActive = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleSOS() {
    if (_isLoading) return;
    
    setState(() {
      _sosActive = !_sosActive;
    });
    
    if (_sosActive) {
      // Show activation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SOS Activated! Sending alert...'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      // Send SOS alert
      _sendSOSAlert();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SOS Alert Deactivated.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              const Text(
                'SOS Emergency Switch',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDD671F),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Description
              const Text(
                'Tap the SOS switch to instantly send SMS alerts to police and your emergency contacts. '
                    'Share your current location and get help fast when every second counts.',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // SOS Switch Button
              GestureDetector(
                onTap: _isLoading ? null : _toggleSOS,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: _isLoading
                        ? Colors.grey
                        : (_sosActive ? Colors.red : const Color(0xFFDD671F)),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_isLoading
                            ? Colors.grey
                            : (_sosActive ? Colors.red : const Color(0xFFDD671F)))
                            .withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: _isLoading
                      ? const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Icon(
                    Icons.warning,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Status Text
              Text(
                _sosActive ? 'SOS ACTIVE' : 'Tap to Activate SOS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _sosActive ? Colors.red : Colors.grey[600],
                ),
              ),

              const SizedBox(height: 30),

              // Check Location Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isCheckingLocation ? null : _checkLocation,
                  icon: _isCheckingLocation
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Icon(Icons.location_searching, size: 24),
                  label: Text(
                    _isCheckingLocation
                        ? 'Checking Location...'
                        : 'Check if Area is Safe',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDD671F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Location Status Card
              if (_currentPosition != null && !_isCheckingLocation)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isDangerArea == null
                        ? Colors.grey[200]
                        : (_isDangerArea!
                        ? Colors.red[50]
                        : Colors.green[50]),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isDangerArea == null
                          ? Colors.grey[300]!
                          : (_isDangerArea!
                          ? Colors.red[300]!
                          : Colors.green[300]!),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isDangerArea == null
                                ? Icons.location_on
                                : (_isDangerArea!
                                ? Icons.warning
                                : Icons.check_circle),
                            color: _isDangerArea == null
                                ? Colors.grey[600]
                                : (_isDangerArea!
                                ? Colors.red
                                : Colors.green),
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              _locationStatus,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _isDangerArea == null
                                    ? Colors.grey[700]
                                    : (_isDangerArea!
                                    ? Colors.red[700]
                                    : Colors.green[700]),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      if (_locationDetails.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          _locationDetails,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

