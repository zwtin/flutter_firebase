import 'package:flutter_firebase/models/event.dart';

abstract class EventListRepository {
  Stream<List<Event>> fetch();
}
