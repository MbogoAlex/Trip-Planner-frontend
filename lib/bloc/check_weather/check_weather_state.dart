import 'package:equatable/equatable.dart';
import 'package:orchestrator/models/weather.dart';

enum CheckingStatus { initial, checking, success, failure }

// ignore: must_be_immutable
class CheckWeatherState extends Equatable {
  CheckingStatus status;
  Weather? weather;

  CheckWeatherState({required this.status, this.weather});

  @override
  List<Object?> get props => [status, weather];
}
