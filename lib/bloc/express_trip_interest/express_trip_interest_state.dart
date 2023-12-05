import 'package:equatable/equatable.dart';

enum ExpressingStatus { initial, expressing, failure, success }

// ignore: must_be_immutable
class ExpressTripInterestState extends Equatable {
  ExpressingStatus status;
  ExpressTripInterestState({required this.status});

  @override
  List<Object?> get props => [status];
}
