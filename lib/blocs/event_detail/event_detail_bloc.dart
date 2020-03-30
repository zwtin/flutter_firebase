import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/event_detail/event_detail_state.dart';
import 'package:flutter_firebase/repositories/event_detail_repository.dart';
import 'package:flutter_firebase/repositories/like_repository.dart';

class EventDetailBloc implements Bloc {
  EventDetailBloc(this._id, this._eventDetailRepository, this._likeRepository)
      : assert(_id != null),
        assert(_eventDetailRepository != null),
        assert(_likeRepository != null) {
    getEventDetail();
  }

  final String _id;
  final EventDetailRepository _eventDetailRepository;
  final LikeRepository _likeRepository;

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

  void likeButtonAction() {
    _likeRepository.like(
      userId: 'UEjZYlyaEdc5wR4IN0VjpiNHE2r1',
      itemId: _id,
    );
  }

  void favoriteButtonAction() {
    _likeRepository.like(
      userId: 'UEjZYlyaEdc5wR4IN0VjpiNHE2r1',
      itemId: _id,
    );
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
  }
}
