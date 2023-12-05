import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:orchestrator/bloc/fetch_trips/fetch_trips_event.dart';
import 'package:orchestrator/bloc/fetch_trips/fetch_trips_state.dart';
import 'package:orchestrator/data/data_repository.dart';
import 'package:orchestrator/models/trip.dart';
import 'package:orchestrator/models/trip_interest.dart';

class FetchTripsBloc extends Bloc<FetchTripsEvent, FetchTripsState> {
  FetchTripsBloc() : super(FetchTripsState(status: FetchingStatus.initial)) {
    on<TripsFetched>(_onTripsFetched);
  }
  Future<void> _onTripsFetched(
      TripsFetched event, Emitter<FetchTripsState> emit) async {
    emit(FetchTripsState(status: FetchingStatus.fetching));
    final response = await DataRepository.fetchTripsrepository(event.userId);

    if (response['success']) {
      final unprocessedTrips = response['trips'];
      List<Trip> tripsYouHaveExpressedInterestIn = [];

      List<Trip> trips = await createTripObjects(unprocessedTrips);
      for (Trip trip in trips) {
        for (TripInterest tripInterest in trip.tripInterests!) {
          if (event.userId == tripInterest.interestedPersonId) {
            tripsYouHaveExpressedInterestIn.add(trip);
          }
        }
      }
      emit(
        FetchTripsState(
            status: FetchingStatus.success,
            trips: trips,
            tripsYouHaveExpressedInterestIn: tripsYouHaveExpressedInterestIn),
      );
    } else {
      emit(FetchTripsState(status: FetchingStatus.failure));
    }
  }

  Future<List<Trip>> createTripObjects(List trips) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
    return Future.wait(
      trips.reversed.map((dynamic json) async {
        return Trip(
          userID: json['userID'],
          tripID: json['tripID'],
          userName: json['userName'],
          message: json['message'],
          dateAndTime: dateFormat.format(DateTime.parse(json['dateAndTime'])),
          location: json['location'],
          tripInterests: await createTripInterestObjects(
            json['location'],
            json['tripInterests'],
          ),
        );
      }),
    );
  }

  Future<List<TripInterest>> createTripInterestObjects(
      String location, List tripInterests) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
    return Future.wait(
      tripInterests.reversed.map((dynamic json) async {
        return TripInterest(
          tripID: json['tripID'],
          location: location,
          interestedPersonId: json['interestedPersonId'],
          proposerUserName: json['proposerUserName'],
          interestedPersonUserName: json['interestedPersonUserName'],
          interestedPersonMessage: json['interestedPersonMessage'],
          localDateTime:
              dateFormat.format(DateTime.parse(json['localDateTime'])),
        );
      }),
    );
  }
}
