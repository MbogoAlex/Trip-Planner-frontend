import 'package:equatable/equatable.dart';

sealed class FetchTripsInterestedInEvent extends Equatable {}

// ignore: must_be_immutable
class TripsInterestedInFetched extends FetchTripsInterestedInEvent {
  int userId;

  TripsInterestedInFetched({required this.userId});

  @override
  List<Object?> get props => [userId];
}
