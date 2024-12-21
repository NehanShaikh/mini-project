import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> login(String username, String password) async {
  final url = Uri.parse('http://localhost:3000/api/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': username, 'password': password}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Login successful: ${data['message']}');
  } else {
    print('Login failed: ${response.body}');
  }
}
