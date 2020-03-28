import 'package:flutter_firebase/models/event.dart';

abstract class EventDetailRepository {
  Stream<Event> getEvent(String id);
}
