import 'package:orchestrator/models/trip_interest.dart';

class Trip {
  int userID;
  int tripID;
  String userName;
  String message;
  String dateAndTime;
  String location;
  List<TripInterest>? tripInterests;

  Trip(
      {required this.userID,
      required this.tripID,
      required this.userName,
      required this.message,
      required this.dateAndTime,
      required this.location,
      this.tripInterests});
}
