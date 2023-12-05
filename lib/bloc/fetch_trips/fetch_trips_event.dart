import 'package:equatable/equatable.dart';

sealed class FetchTripsEvent extends Equatable {}

// ignore: must_be_immutable
class TripsFetched extends FetchTripsEvent {
  int? userId;
  TripsFetched({this.userId});
  @override
  List<Object?> get props => [userId];
}
