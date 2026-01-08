import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({Key? key}) : super(key: key);

  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  final _storage = FlutterSecureStorage();
  String email = '';
  String fullName = '';
  String phoneNumber = '';
  String emergencyContact = '';
  String policeContact = '';
  bool isLoading = true;
  
  // Controllers for editing emergency contacts
  final TextEditingController _emergencyContactController = TextEditingController();
  final TextEditingController _policeContactController = TextEditingController();
  bool _isEditingEmergency = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchProfileInfo();
  }

  @override
  void dispose() {
    _emergencyContactController.dispose();
    _policeContactController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfileInfo() async {
    String? userId = await _storage.read(key: 'userId');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found. Please log in again.')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final url = '${Config.baseUrl}/user/profile/mobile?user_id=$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Request timeout - Server did not respond in time');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          setState(() {
            fullName = data['data']['full_name'] ?? '';
            email = data['data']['email'] ?? '';
            phoneNumber = data['data']['phone_number'] ?? '';
            emergencyContact = data['data']['emergency_contact'] ?? '';
            policeContact = data['data']['police_contact'] ?? '';
            
            // Set controller values
            _emergencyContactController.text = emergencyContact;
            _policeContactController.text = policeContact;
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(data['message'] ?? 'Failed to fetch profile')),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to fetch profile data.')),
          );
        }
      }
    } catch (e) {
      String errorMessage = 'An error occurred';
      if (e.toString().contains('timeout') || e is TimeoutException) {
        errorMessage = 'Request timeout. Please check your internet connection.';
      } else if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        errorMessage = 'Cannot connect to server. Please check your internet connection.';
      } else {
        errorMessage = 'Error: ${e.toString()}';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _saveEmergencyContacts() async {
    String? userId = await _storage.read(key: 'userId');
    if (userId == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/user/update-emergency-contacts'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': int.parse(userId),
          'emergency_contact': _emergencyContactController.text.trim(),
          'police_contact': _policeContactController.text.trim(),
        }),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Request timeout - Server did not respond in time');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            emergencyContact = _emergencyContactController.text.trim();
            policeContact = _policeContactController.text.trim();
            _isEditingEmergency = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Emergency contacts updated successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Failed to update contacts')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update emergency contacts')),
          );
        }
      }
    } catch (e) {
      String errorMessage = 'An error occurred';
      if (e.toString().contains('timeout') || e is TimeoutException) {
        errorMessage = 'Request timeout. Please check your internet connection.';
      } else if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        errorMessage = 'Cannot connect to server. Please check your internet connection.';
      } else {
        errorMessage = 'Error: ${e.toString()}';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Info'),
        backgroundColor: const Color(0xFFDD671F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Icon
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Profile Information Section
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDD671F),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildInfoRow('Full Name:', fullName),
                          const Divider(),
                          _buildInfoRow('Email:', email),
                          const Divider(),
                          _buildInfoRow('Phone Number:', phoneNumber),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Emergency Contacts Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Emergency Contacts',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDD671F),
                        ),
                      ),
                      if (!_isEditingEmergency)
                        IconButton(
                          icon: const Icon(Icons.edit, color: Color(0xFFDD671F)),
                          onPressed: () {
                            setState(() {
                              _isEditingEmergency = true;
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _isEditingEmergency
                          ? Column(
                              children: [
                                TextField(
                                  controller: _emergencyContactController,
                                  decoration: const InputDecoration(
                                    labelText: 'Emergency Contact Number',
                                    hintText: 'Enter emergency contact number',
                                    prefixIcon: Icon(Icons.phone, color: Color(0xFFDD671F)),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 15),
                                TextField(
                                  controller: _policeContactController,
                                  decoration: const InputDecoration(
                                    labelText: 'Police Contact Number',
                                    hintText: 'Enter police contact number',
                                    prefixIcon: Icon(Icons.local_police, color: Color(0xFFDD671F)),
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: _isSaving
                                          ? null
                                          : () {
                                              setState(() {
                                                _isEditingEmergency = false;
                                                _emergencyContactController.text = emergencyContact;
                                                _policeContactController.text = policeContact;
                                              });
                                            },
                                      child: const Text('Cancel'),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: _isSaving ? null : _saveEmergencyContacts,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFDD671F),
                                      ),
                                      child: _isSaving
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : const Text('Save'),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildInfoRow('Emergency Contact:', emergencyContact.isEmpty ? 'Not set' : emergencyContact),
                                const Divider(),
                                _buildInfoRow('Police Contact:', policeContact.isEmpty ? 'Not set' : policeContact),
                              ],
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Go Back Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDD671F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Go Back'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
