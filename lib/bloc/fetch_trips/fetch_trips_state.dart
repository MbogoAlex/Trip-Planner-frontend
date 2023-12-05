import 'package:equatable/equatable.dart';
import 'package:orchestrator/models/trip.dart';

enum FetchingStatus { initial, fetching, success, failure }

// ignore: must_be_immutable
class FetchTripsState extends Equatable {
  FetchingStatus status;
  List<Trip>? trips;
  List<Trip>? tripsYouHaveExpressedInterestIn;

  FetchTripsState(
      {required this.status, this.trips, this.tripsYouHaveExpressedInterestIn});

  @override
  List<Object?> get props => [trips, tripsYouHaveExpressedInterestIn];
}
