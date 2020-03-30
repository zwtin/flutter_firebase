import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_firebase/entities/event.dart';

@immutable
abstract class EventDetailState extends Equatable {}

class EventDetailInProgress extends EventDetailState {
  @override
  List<Object> get props => [];
}

class EventDetailSuccess extends EventDetailState {
  EventDetailSuccess({@required this.event}) : assert(event != null);

  final Stream<Event> event;

  @override
  List<Object> get props => [event];
}

class EventDetailFailure extends EventDetailState {
  EventDetailFailure({@required this.exception}) : assert(exception != null);

  final Exception exception;

  @override
  List<Object> get props => [exception];
}
