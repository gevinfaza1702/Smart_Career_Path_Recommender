import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl =
      'http://10.0.2.2:5000'; // ini WAJIB untuk emulator Android

  /// Sends selected skills to the Flask API and returns the parsed JSON.
  static Future<Map<String, dynamic>> predictCareer(List<String> skills) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/predict-career'), // ← gunakan _baseUrl
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'skills': skills}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to get prediction: ${response.statusCode}');
    }
  }
}
