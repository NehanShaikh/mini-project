import 'dart:convert';
import 'package:http/http.dart' as http;

class AttendanceService {
  final String baseUrl =
      'http://your-server-ip:3000'; // Replace with your backend's URL

  Future<List<Map<String, dynamic>>> fetchAttendance() async {
    final response = await http.get(Uri.parse('$baseUrl/attendance'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load attendance');
    }
  }

  Future<void> logAttendance(String subject, String timestamp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/attendance'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'subject': subject, 'timestamp': timestamp}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to log attendance');
    }
  }
}
