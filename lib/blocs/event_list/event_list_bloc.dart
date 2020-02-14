import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_event.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_repository.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_state.dart';

class EventListBloc extends Bloc<EventListEvent, EventListState> {
  EventListBloc({@required EventListRepository eventListRepository})
      : assert(eventListRepository != null),
        _eventListRepository = eventListRepository;

  final EventListRepository _eventListRepository;

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
}
