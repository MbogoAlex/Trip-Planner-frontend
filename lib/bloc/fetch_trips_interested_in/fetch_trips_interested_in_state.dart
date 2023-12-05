import 'package:equatable/equatable.dart';
import 'package:orchestrator/models/trip_interest.dart';

enum FetchingStatus { initial, fetching, success, failure }

// ignore: must_be_immutable
class FetchTripsInterestedInState extends Equatable {
  FetchingStatus status;
  List<TripInterest>? tripsInterestedIn;

  FetchTripsInterestedInState({required this.status, this.tripsInterestedIn});

  @override
  List<Object?> get props => [status, tripsInterestedIn];
}
