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
  bool likeState = false;
  bool favoriteState = false;
  final EventDetailRepository _eventDetailRepository;

  final _stateController = StreamController<EventDetailState>();
  final _likeController = StreamController<bool>();
  final _favoriteController = StreamController<bool>();

  // output
  Stream<EventDetailState> get screenState => _stateController.stream;
  Stream<bool> get like => _likeController.stream;
  Stream<bool> get favorite => _favoriteController.stream;

  void getEventDetail() {
    try {
      final event = _eventDetailRepository.getEvent(_id);
      _stateController.sink.add(EventDetailSuccess(event: event));
    } on Exception catch (error) {
      _stateController.sink.add(EventDetailFailure(exception: error));
    }
  }

  void likeButtonAction() {
    likeState = !likeState;
    _likeController.sink.add(likeState);
  }

  void favoriteButtonAction() {
    favoriteState = !favoriteState;
    _favoriteController.sink.add(favoriteState);
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
    await _likeController.close();
    await _favoriteController.close();
  }
}
