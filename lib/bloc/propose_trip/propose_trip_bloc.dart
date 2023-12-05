import 'package:bloc/bloc.dart';
import 'package:orchestrator/bloc/propose_trip/propose_trip_event.dart';
import 'package:orchestrator/bloc/propose_trip/propose_trip_state.dart';
import 'package:orchestrator/data/data_repository.dart';

class ProposeTripBloc extends Bloc<PropseTripEvent, ProposeTripState> {
  ProposeTripBloc() : super(ProposeTripState(status: ProposingStatus.initial)) {
    on<TripProposed>(_onTripProposed);
  }
  Future<void> _onTripProposed(
      TripProposed event, Emitter<ProposeTripState> emit) async {
    emit(ProposeTripState(status: ProposingStatus.proposing));

    Map<String, dynamic> trip = {
      "userID": event.userId,
      "userName": event.userName,
      "message": event.message,
      "location": event.location
    };

    final response = await DataRepository.createTripRepository(trip);

    if (response['success']) {
      emit(ProposeTripState(status: ProposingStatus.success));
    } else {
      emit(ProposeTripState(status: ProposingStatus.failure));
    }
  }
}
