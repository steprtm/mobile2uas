import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/login.dart';

class LoginBloc {
  static Future<Login> login({
    String? email,
    String? password,
  }) async {
    String apiUrl = ApiUrl.login;
    var body = {
      "email": email,
      "password": password,
    };

    try {
      // Logging the request details
      print('Request URL: $apiUrl');
      print('Request Body: ${json.encode(body)}');

      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      // Logging the response details
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonObj = json.decode(response.body);
        print('Parsed JSON: $jsonObj');
        return Login.fromJson(jsonObj);
      } else {
        print('Failed to login. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Error during login');
    }
  }
}
