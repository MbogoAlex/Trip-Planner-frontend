import 'package:orchestrator/data/data_provider.dart';

class DataRepository {
  static Future<Map<String, dynamic>> saveUserRepository(
      String userName) async {
    DataProvider dataProvider = DataProvider();
    final body = await dataProvider.saveUser(userName);
    return body;
  }

  static Future<Map<String, dynamic>> fetchTripsrepository(int? userId) async {
    DataProvider dataProvider = DataProvider();
    final body = await dataProvider.fetchTrips(userId);
    return body;
  }

  static Future<Map<String, dynamic>> createTripRepository(
      Map<String, dynamic> trip) async {
    DataProvider dataProvider = DataProvider();
    final body = await dataProvider.createTrip(trip);
    return body;
  }

  static Future<Map<String, dynamic>> checkWeatherRepository(
      String location) async {
    DataProvider dataProvider = DataProvider();
    final body = await dataProvider.checkWeather(location);
    return body;
  }

  static Future<Map<String, dynamic>> expressTripInterestRepository(
      Map<String, dynamic> tripInterest) async {
    DataProvider dataProvider = DataProvider();
    final body = await dataProvider.expressTripInterest(tripInterest);
    return body;
  }

  static Future<Map<String, dynamic>> fetchTripsInterestedInRepository(
      int userId) async {
    DataProvider dataProvider = DataProvider();
    final body = await dataProvider.fetchTripsInterestedIn(userId);
    return body;
  }
}
