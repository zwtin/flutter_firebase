import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/repositories/event_list_repository.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_state.dart';
import 'package:flutter_firebase/repositories/storage_repository.dart';

class EventListBloc implements Bloc {
  EventListBloc(this._eventListRepository, this._storageRepository)
      : assert(_eventListRepository != null),
        assert(_storageRepository != null) {
    _start();
  }

  final EventListRepository _eventListRepository;
  final StorageRepository _storageRepository;

  final _stateController = StreamController<EventListState>();
  final _readController = StreamController<void>();

  // input
  StreamSink<void> get read => _readController.sink;
  // output
  Stream<EventListState> get onAdd => _stateController.stream;

  void _start() {
    _stateController.sink
        .add(EventListSuccess(eventList: _eventListRepository.fetch()));
  }

  @override
  Future<void> dispose() async {
    await _stateController.close();
    await _readController.close();
  }
}
