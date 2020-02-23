import 'dart:async';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_repository.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_state.dart';

class EventListBloc implements Bloc {
  EventListBloc(this._eventListRepository)
      : assert(_eventListRepository != null) {
    _readController.stream.listen((_) => _start());
  }

  final EventListRepository _eventListRepository;

  final _stateController = StreamController<EventListState>();
  final _readController = StreamController<void>();

  // input
  StreamSink<void> get read => _readController.sink;
  // output
  Stream<EventListState> get onAdd => _stateController.stream;

  void _start() {
    _stateController.sink.add(EventListInProgress());
    Timer(const Duration(seconds: 3), _onTimer);
  }

  void _onTimer() {
    _stateController.sink.add(EventListEmpty());
  }

  /*
  @override
  EventListState get initialState => EventListEmpty();

  @override
  Stream<EventListState> mapEventToState(EventListEvent event) async* {
    if (event is EventListLoad) {
      yield* _mapEventListLoadToState();
    }
  }

  Stream<EventListState> _mapEventListLoadToState() async* {
    yield EventListInProgress();
    try {
      yield EventListSuccess(eventList: _eventListRepository.fetch());
    } on Exception catch (e) {
      yield EventListFailure(exception: e);
    }
  }
  */
  @override
  Future<void> dispose() async {
    await _stateController.close();
    await _readController.close();
  }
}
