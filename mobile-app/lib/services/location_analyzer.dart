import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationAnalyzer {
  /// Analyzes location to determine if it's a danger area or safe area
  /// Returns true if danger (quiet/isolated), false if safe (crowded/populated)
  /// Logic: More people = safer, fewer people = more dangerous
  Future<bool> isDangerArea(double latitude, double longitude) async {
    try {
      // Use Nominatim reverse geocoding to get location type
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&addressdetails=1&zoom=18'
        ),
        headers: {
          'User-Agent': 'SmartSafetyWelfareApp/1.0',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'] ?? {};
        
        // Extract location information
        final type = (address['type'] ?? '').toLowerCase();
        final placeType = (address['place_type'] ?? '').toLowerCase();
        final placeClass = (address['place_class'] ?? '').toLowerCase();
        
        // SAFE AREAS: Crowded/populated areas (more people = safer)
        final safeIndicators = [
          'city',
          'town',
          'commercial',
          'retail',
          'industrial',
          'urban',
          'suburb',
          'residential', // Residential areas usually have people nearby
        ];
        
        // DANGER AREAS: Quiet/isolated areas (fewer people = more dangerous)
        final dangerIndicators = [
          'rural',
          'forest',
          'farm',
          'village',
          'hamlet',
          'countryside',
          'country',
        ];
        
        // Check type, place_type, and place_class
        final locationString = '$type $placeType $placeClass'.toLowerCase();
        
        // If any danger indicator is found, it's a danger area (isolated/quiet)
        if (dangerIndicators.any((indicator) => locationString.contains(indicator))) {
          return true; // Danger area (isolated/quiet)
        }
        
        // If any safe indicator is found, it's a safe area (crowded/populated)
        if (safeIndicators.any((indicator) => locationString.contains(indicator))) {
          return false; // Safe area (crowded/populated)
        }
        
        // Fallback: Check if it's a named populated place
        if (address['city'] != null || address['town'] != null) {
          return false; // Likely safe (crowded)
        }
        
        if (address['village'] != null || address['hamlet'] != null || address['rural'] != null) {
          return true; // Likely danger (isolated)
        }
        
        // Default: If we can't determine, assume danger (isolated/unknown)
        return true;
      }
    } catch (e) {
      print('Error analyzing location: $e');
    }
    
    // Default to danger if we can't determine (unknown/isolated)
    return true;
  }
  
  /// Gets location details for display
  Future<Map<String, String>> getLocationDetails(double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&addressdetails=1'
        ),
        headers: {
          'User-Agent': 'SmartSafetyWelfareApp/1.0',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'] ?? {};
        
        return {
          'display_name': data['display_name'] ?? 'Unknown Location',
          'type': address['type'] ?? 'unknown',
          'city': address['city'] ?? address['town'] ?? address['village'] ?? '',
        };
      }
    } catch (e) {
      print('Error getting location details: $e');
    }
    
    return {
      'display_name': 'Unknown Location',
      'type': 'unknown',
      'city': '',
    };
  }
}

