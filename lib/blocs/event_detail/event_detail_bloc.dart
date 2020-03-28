import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/event_detail/event_detail_state.dart';
import 'package:flutter_firebase/blocs/event_detail/event_detail_repository.dart';

class EventDetailBloc implements Bloc {
  EventDetailBloc(this._id, this._eventDetailRepository)
      : assert(_id != null),
        assert(_eventDetailRepository != null) {
    getEventDetail();
  }

  final String _id;
  final EventDetailRepository _eventDetailRepository;

  final _stateController = StreamController<EventDetailState>();

  // output
  Stream<EventDetailState> get screenState => _stateController.stream;

  void getEventDetail() {
    try {
      final event = _eventDetailRepository.getEvent(_id);
      _stateController.sink.add(EventDetailSuccess(event: event));
    } on Exception catch (error) {
      _stateController.sink.add(EventDetailFailure(exception: error));
    }
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
  }
}
