class TripInterest {
  int tripID;
  String location;
  int interestedPersonId;
  String proposerUserName;
  String interestedPersonUserName;
  String interestedPersonMessage;
  String localDateTime;

  TripInterest(
      {required this.tripID,
      required this.location,
      required this.interestedPersonId,
      required this.proposerUserName,
      required this.interestedPersonUserName,
      required this.interestedPersonMessage,
      required this.localDateTime});
}
