import 'dart:convert';

import 'package:checkinlokasi/consts/api.dart';
import 'package:checkinlokasi/modules/location/models/location_response_model.dart';
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
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<LocationResponse?> getLocations() async {
    try {
      final response = await http.get(
        Uri.parse(BASE_TRACKING_URL),
        headers: await _getHeaders(),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return LocationResponse.fromJson(responseData);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> addLocation({
    required String placeName,
    required String placeType,
    required String comment,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          BASE_TRACKING_URL /* +"?tindakan=simpan&placeName=$placeName" */,
        ),
        headers: await _getHeaders(),
        body: jsonEncode({
          "data": {
            "placeName": placeName,
            "placeType": placeType,
            "comment": comment,
            "latitude": latitude,
            "longitude": longitude,
          },
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateLocation({
    required String id,
    required String placeName,
    required String placeType,
    required String comment,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(BASE_TRACKING_URL + "/$id"),
        headers: await _getHeaders(),
        body: jsonEncode({
          "data": {
            "placeName": placeName,
            "placeType": placeType,
            "comment": comment,
            "latitude": latitude,
            "longitude": longitude,
          },
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deleteLocation(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(BASE_TRACKING_URL + "/$id"),
        headers: await _getHeaders(),
      );
      return response.statusCode == 204;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
