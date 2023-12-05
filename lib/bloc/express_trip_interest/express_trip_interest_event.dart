import 'package:equatable/equatable.dart';

sealed class ExpressTripInterestEvent extends Equatable {}

// ignore: must_be_immutable
class TripInterestExpressed extends ExpressTripInterestEvent {
  int tripID;
  int interestedPersonId;
  String proposerUserName;
  String interestedPersonUserName;
  String interestedPersonMessage;

  TripInterestExpressed(
      {required this.tripID,
      required this.interestedPersonId,
      required this.proposerUserName,
      required this.interestedPersonUserName,
      required this.interestedPersonMessage});

  @override
  List<Object?> get props => [
        tripID,
        interestedPersonId,
        proposerUserName,
        interestedPersonUserName,
        interestedPersonMessage
      ];
}
