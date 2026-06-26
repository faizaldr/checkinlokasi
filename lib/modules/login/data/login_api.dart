import 'dart:convert';

import 'package:checkinlokasi/consts/api.dart';
import 'package:http/http.dart' as http;
import 'package:checkinlokasi/modules/login/models/login_response_model.dart';

class LoginApi {
  Future<LoginResponse?> login(String identifier, String password) async {
    try {
      final response = await http.post(
        Uri.parse(AUTH_LOGIN_URL),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"identifier": identifier, "password": password}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return LoginResponse.fromJson(responseData);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<LoginResponse?> loginWithGoogle({String? idToken, String? accessToken}) async {
    try {
      final response = await http.post(
        Uri.parse(AUTH_GOOGLE_MOBILE_URL),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idToken": idToken, "accessToken": accessToken}),
      );
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      // Ignore
    }
    return null;
  }
}
