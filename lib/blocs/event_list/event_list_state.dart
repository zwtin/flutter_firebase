import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_firebase/models/event.dart';

@immutable
abstract class EventListState extends Equatable {
}

class EventListEmpty extends EventListState {
    @override
    List<Object> get props => [];
}

class EventListInProgress extends EventListState {
    @override
    List<Object> get props => [];
}

class EventListSuccess extends EventListState {
    final Stream<List<Event>> eventList;

    EventListSuccess({@required this.eventList})
        : assert(eventList != null);

    @override
    List<Object> get props => [eventList];
}

class EventListFailure extends EventListState {
    final Error error;

    EventListFailure({@required this.error})
        : assert(error != null);

    @override
    List<Object> get props => [error];
}
