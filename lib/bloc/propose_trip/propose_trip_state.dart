import 'package:equatable/equatable.dart';

enum ProposingStatus { initial, proposing, success, failure }

// ignore: must_be_immutable
class ProposeTripState extends Equatable {
  ProposingStatus status;
  ProposeTripState({required this.status});
  @override
  List<Object?> get props => [status];
}
