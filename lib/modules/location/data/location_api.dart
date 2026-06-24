import 'package:checkinlokasi/modules/login/data/login_db.dart';
import 'package:http/http.dart' as http;
class LocationApi {
  final LoginDb _loginDb = LoginDb();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _loginDb.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization']='Bearer $token';
    }
    return headers;
  }
}
