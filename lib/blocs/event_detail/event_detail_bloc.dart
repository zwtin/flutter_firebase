import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/event_detail/event_detail_state.dart';
import 'package:flutter_firebase/repositories/event_repository.dart';
import 'package:flutter_firebase/repositories/like_repository.dart';
import 'package:flutter_firebase/repositories/sign_in_repository.dart';
import 'package:rxdart/rxdart.dart';

class EventDetailBloc implements Bloc {
  EventDetailBloc(
    this._id,
    this._eventRepository,
    this._likeRepository,
    this._signInRepository,
  )   : assert(_id != null),
        assert(_eventRepository != null),
        assert(_likeRepository != null),
        assert(_signInRepository != null) {
    getEventDetail();
  }

  final String _id;
  final EventRepository _eventRepository;
  final LikeRepository _likeRepository;
  final SignInRepository _signInRepository;

  final _stateController = StreamController<EventDetailState>();

  // output
  Stream<EventDetailState> get screenState => _stateController.stream;

  void getEventDetail() {
    try {
      final event = _eventRepository.getEventDetail(_id);
      _stateController.sink.add(EventDetailSuccess(event: event));
    } on Exception catch (error) {
      _stateController.sink.add(EventDetailFailure(exception: error));
    }
  }

  Future<void> likeButtonAction() async {
    final currentUser = await _signInRepository.getCurrentUser();
    await _likeRepository.like(
      userId: currentUser.id,
      itemId: _id,
    );
  }

  Future<void> favoriteButtonAction() async {
    final currentUser = await _signInRepository.getCurrentUser();
    await _likeRepository.like(
      userId: currentUser.id,
      itemId: _id,
    );
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
  }
}
