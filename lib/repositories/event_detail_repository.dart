import 'package:flutter_firebase/entities/event.dart';

abstract class EventDetailRepository {
  Stream<Event> getEvent(String id);
}
