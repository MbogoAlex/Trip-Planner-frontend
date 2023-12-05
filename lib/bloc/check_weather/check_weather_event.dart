import 'package:equatable/equatable.dart';

sealed class CheckWeatherEvent extends Equatable {}

// ignore: must_be_immutable
class WeatherChecked extends CheckWeatherEvent {
  String location;
  WeatherChecked({required this.location});
  @override
  List<Object?> get props => [location];
}
