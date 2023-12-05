import 'package:bloc/bloc.dart';
import 'package:orchestrator/bloc/express_trip_interest/express_trip_interest_event.dart';
import 'package:orchestrator/bloc/express_trip_interest/express_trip_interest_state.dart';
import 'package:orchestrator/data/data_repository.dart';

class ExpressTripInterestBloc
    extends Bloc<ExpressTripInterestEvent, ExpressTripInterestState> {
  ExpressTripInterestBloc()
      : super(ExpressTripInterestState(status: ExpressingStatus.initial)) {
    on<TripInterestExpressed>(_onTripInterestExpressed);
  }
  Future<void> _onTripInterestExpressed(TripInterestExpressed event,
      Emitter<ExpressTripInterestState> emit) async {
    emit(ExpressTripInterestState(status: ExpressingStatus.expressing));

    Map<String, dynamic> tripInterest = {
      "tripID": event.tripID,
      "interestedPersonId": event.interestedPersonId,
      "proposerUserName": event.proposerUserName,
      "interestedPersonUserName": event.interestedPersonUserName,
      "interestedPersonMessage": event.interestedPersonMessage,
    };

    final body =
        await DataRepository.expressTripInterestRepository(tripInterest);

    if (body['success']) {
      emit(ExpressTripInterestState(status: ExpressingStatus.success));
    } else {
      emit(ExpressTripInterestState(status: ExpressingStatus.failure));
    }
  }
}
