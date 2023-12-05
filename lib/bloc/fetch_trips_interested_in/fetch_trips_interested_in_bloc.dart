// import 'package:bloc/bloc.dart';
// import 'package:orchestrator/bloc/fetch_trips_interested_in/fetch_trips_interested_in_event.dart';
// import 'package:orchestrator/bloc/fetch_trips_interested_in/fetch_trips_interested_in_state.dart';
// import 'package:orchestrator/data/data_repository.dart';
// import 'package:orchestrator/models/trip_interest.dart';

// class FetchTripsInterestedInBloc
//     extends Bloc<FetchTripsInterestedInEvent, FetchTripsInterestedInState> {
//   FetchTripsInterestedInBloc()
//       : super(FetchTripsInterestedInState(status: FetchingStatus.initial)) {
//     on<TripsInterestedInFetched>(_onTripsInterestedInFetched);
//   }
//   Future<void> _onTripsInterestedInFetched(TripsInterestedInFetched event,
//       Emitter<FetchTripsInterestedInState> emit) async {
//     emit(FetchTripsInterestedInState(status: FetchingStatus.fetching));

//     final body = await DataRepository.fetchTripsInterestedInRepository(event.userId);
//     if(body['success']){
//       final trips = await processTrips(body['trips']);
//     }
//   }
//   Future<List<TripInterest>> processTrips(List trips) async {
//     return trips.reversed.map((dynamic json){
//       return TripInterest(tripID: json['tripID'], location: location, interestedPersonId: interestedPersonId, proposerUserName: proposerUserName, interestedPersonUserName: interestedPersonUserName, interestedPersonMessage: interestedPersonMessage, localDateTime: localDateTime)
//     })
//   }
// }
