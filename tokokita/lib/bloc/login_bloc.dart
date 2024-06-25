import 'dart:convert';
import 'package:tokokita/helpers/api.dart';
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
      var response = await Api().post(apiUrl, body);
      if (response.statusCode == 200) {
        var jsonObj = json.decode(response.body);
        return Login.fromJson(jsonObj);
      } else {
        // Handle unexpected status codes or errors
        print('Failed to login. Status code: ${response.statusCode}');
        throw Exception('Failed to login');
      }
    } catch (e) {
      // Handle network errors or exceptions
      print('Error during login: $e');
      throw Exception('Error during login');
    }
  }
}
