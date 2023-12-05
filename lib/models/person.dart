import 'package:orchestrator/models/trip_interest.dart';

class Person {
  int userId;
  String userName;
  List<TripInterest>? tripInterests;

  Person({required this.userId, required this.userName, this.tripInterests});
}
