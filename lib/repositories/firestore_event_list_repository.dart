import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_repository.dart';
import 'package:flutter_firebase/models/event.dart';

class FirestoreEventListRepository extends EventListRepository {
  FirestoreEventListRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

  final Firestore _firestore;

  @override
  Stream<List<Event>> fetch() {
    return _firestore.collection('events').snapshots().map((snapshot) {
      return snapshot.documents.map((docs) {
        return Event(
          id: docs.documentID,
          title: docs.data['title'] as String,
          description: docs.data['description'] as String,
          date: docs.data['date']?.toDate() as DateTime,
          imageUrl: docs.data['image_url'] as String,
        );
      }).toList();
    });
  }
}
