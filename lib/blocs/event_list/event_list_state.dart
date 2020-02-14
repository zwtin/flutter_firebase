import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_firebase/models/event.dart';

@immutable
abstract class EventListState extends Equatable {}

class EventListEmpty extends EventListState {
  @override
  List<Object> get props => [];
}

class EventListInProgress extends EventListState {
  @override
  List<Object> get props => [];
}

class EventListSuccess extends EventListState {
  EventListSuccess({@required this.eventList}) : assert(eventList != null);

  final Stream<List<Event>> eventList;

  @override
  List<Object> get props => [eventList];
}

class EventListFailure extends EventListState {
  EventListFailure({@required this.exception}) : assert(exception != null);

  final Exception exception;

  @override
  List<Object> get props => [exception];
}
