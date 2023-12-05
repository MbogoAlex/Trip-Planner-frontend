import 'package:equatable/equatable.dart';

sealed class PropseTripEvent extends Equatable {}

// ignore: must_be_immutable
class TripProposed extends PropseTripEvent {
  int userId;
  String userName;
  String message;
  String location;

  TripProposed(
      {required this.userId,
      required this.userName,
      required this.message,
      required this.location});

  @override
  List<Object?> get props => [userId, userName, message, location];
}
