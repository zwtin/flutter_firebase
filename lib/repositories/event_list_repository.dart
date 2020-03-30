import 'package:flutter_firebase/entities/event.dart';

abstract class EventListRepository {
  Stream<List<Event>> fetch();
}
