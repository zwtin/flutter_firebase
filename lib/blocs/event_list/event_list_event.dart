import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EventListEvent extends Equatable {}

class EventListLoad extends EventListEvent {
  @override
  List<Object> get props => [];
}
