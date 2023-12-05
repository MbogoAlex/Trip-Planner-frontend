import 'dart:convert';

import 'package:http/http.dart' as http;

class DataProvider {
  static String baseUrl = "http://192.168.181.6:5000";

  Future<Map<String, dynamic>> saveUser(String userName) async {
    final person = {"userName": userName};
    final response = await http.post(
      //Connecting with backend

      Uri.parse("$baseUrl/createAccount"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(person),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      int userId = responseBody['userID'];
      // print("USERID: $userId");
      return {"success": true, "userId": userId};
    } else {
      return {"success": false};
    }
  }

  Future<Map<String, dynamic>> fetchTrips(int? userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/trips"),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return {"success": true, "trips": body};
    } else {
      return {"success": false};
    }
  }

  Future<Map<String, dynamic>> createTrip(Map<String, dynamic> trip) async {
    final response = await http.post(
      Uri.parse("$baseUrl/createTrip"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(trip),
    );
    if (response.statusCode == 200) {
      return {"success": true};
    } else {
      return {"success": false};
    }
  }

  Future<Map<String, dynamic>> checkWeather(String location) async {
    final response = await http.get(
      Uri.parse("$baseUrl/getWeather/$location"),
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      body['success'] = true;
      return body;
    }
    return {"success": false};
  }

  Future<Map<String, dynamic>> expressTripInterest(
      Map<String, dynamic> tripInterest) async {
    // print("PROPOSING TRIP::\n");
    // print(tripInterest);
    final response = await http.post(
      Uri.parse("$baseUrl/expressTripInterest"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(tripInterest),
    );

    if (response.statusCode == 200) {
      return {"success": true};
    } else {
      return {"success": false};
    }
  }

  Future<Map<String, dynamic>> fetchTripsInterestedIn(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/findTripInterestsExpressedByUser/$userId"),
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return {"success": true, "trips": body};
    } else {
      return {"success": false};
    }
  }
}
