import 'package:flutter_firebase/entities/event.dart';

abstract class EventRepository {
  Stream<List<Event>> getEventList();
  Stream<Event> getEventDetail(String id);
}
