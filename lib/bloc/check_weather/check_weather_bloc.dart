import 'package:bloc/bloc.dart';
import 'package:orchestrator/bloc/check_weather/check_weather_event.dart';
import 'package:orchestrator/bloc/check_weather/check_weather_state.dart';
import 'package:orchestrator/data/data_repository.dart';
import 'package:orchestrator/models/weather.dart';

class CheckWeatherBloc extends Bloc<CheckWeatherEvent, CheckWeatherState> {
  CheckWeatherBloc()
      : super(CheckWeatherState(status: CheckingStatus.initial)) {
    on<WeatherChecked>(_onWeatherChecked);
  }
  Future<void> _onWeatherChecked(
      WeatherChecked event, Emitter<CheckWeatherState> emit) async {
    emit(CheckWeatherState(status: CheckingStatus.checking));

    final response =
        await DataRepository.checkWeatherRepository(event.location);
    if (response['success']) {
      final weather = Weather(
        date: response['date'],
        temperature: response['temperature'],
        currentCondition: response['currentCondition'],
        prediction: response['prediction'],
      );
      emit(CheckWeatherState(status: CheckingStatus.success, weather: weather));
    } else {
      emit(CheckWeatherState(status: CheckingStatus.failure));
    }
  }
}
