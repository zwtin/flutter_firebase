import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/repositories/event_list_repository.dart';
import 'package:flutter_firebase/entities/event.dart';
import 'package:flutter_firebase/repositories/event_detail_repository.dart';

class FirestoreEventListRepository
    implements EventListRepository, EventDetailRepository {
  FirestoreEventListRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore.instance;

  final Firestore _firestore;

  @override
  Stream<List<Event>> fetch() {
    return _firestore.collection('items').snapshots().map(
      (snapshot) {
        return snapshot.documents.map(
          (docs) {
            return Event(
              id: docs.documentID,
              title: docs.data['title'] as String,
              description: docs.data['description'] as String,
              date: docs.data['date']?.toDate() as DateTime,
              imageUrl: docs.data['image_url'] as String,
              isOwnLike: false,
            );
          },
        ).toList();
      },
    );
  }

  @override
  Stream<Event> getEvent(String id) {
    return Rx.combineLatest2(
      _firestore.collection('items').document(id).snapshots(),
      _firestore
          .collection('items')
          .document(id)
          .collection('liked_users')
          .document('UEjZYlyaEdc5wR4IN0VjpiNHE2r1')
          .snapshots(),
      (DocumentSnapshot snapshot, DocumentSnapshot streamB) {
        return Event(
          id: snapshot.data['id'] as String,
          title: snapshot.data['title'] as String,
          description: snapshot.data['description'] as String,
          date: (snapshot.data['date'] as Timestamp).toDate(),
          imageUrl: snapshot.data['image_url'] as String,
          isOwnLike: streamB.exists,
        );
      },
    );
  }
}
