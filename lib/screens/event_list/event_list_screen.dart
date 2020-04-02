import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_state.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_bloc.dart';
import 'package:flutter_firebase/entities/event.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firestore_like_repository.dart';
import 'package:flutter_firebase/screens/event_detail/event_detail_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_firebase/blocs/event_detail/event_detail_bloc.dart';
import 'package:flutter_firebase/models/firestore_event_repository.dart';
import 'package:flutter_firebase/blocs/tab/tab_bloc.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen(this.tabBloc) : assert(tabBloc != null);
  final TabBloc tabBloc;

  @override
  Widget build(BuildContext context) {
    final eventListBloc = BlocProvider.of<EventListBloc>(context);

    return StreamBuilder<EventListState>(
      stream: eventListBloc.onAdd,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is EventListInProgress) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'ホーム',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.orange,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData && snapshot.data is EventListEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'ホーム',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.orange,
            ),
            body: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: InkWell(
                    onTap: () => eventListBloc.read.add(null),
                    child: Padding(
                      child: Text(
                        '$index',
                        style: TextStyle(fontSize: 22.0),
                      ),
                      padding: EdgeInsets.all(20.0),
                    ),
                  ),
                );
              },
              itemCount: 30,
            ),
          );
        } else if (snapshot.hasData && snapshot.data is EventListFailure) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'ホーム',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.orange,
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('no user login'),
                  RaisedButton(
                    child: const Text('Button'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () => eventListBloc.read.add(null),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasData && snapshot.data is EventListSuccess) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'ホーム',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.orange,
            ),
            body: StreamBuilder(
              stream: (snapshot.data as EventListSuccess).eventList,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    final event = snapshot.data[index];

                    return Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<EventDetailScreen>(
                              builder: (context) {
                                return BlocProvider<EventDetailBloc>(
                                  creator: (_context, _bag) {
                                    return EventDetailBloc(
                                      event.id,
                                      FirestoreEventRepository(),
                                      FirestoreLikeRepository(),
                                      FirebaseAuthenticationRepository(),
                                    );
                                  },
                                  child: EventDetailScreen(),
                                );
                              },
                            ),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                event.title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(event.date.toIso8601String()),
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 128,
                                  height: 128,
                                  child: FutureBuilder<dynamic>(
                                    future: FirebaseStorage.instance
                                        .ref()
                                        .child(event.imageUrl)
                                        .getDownloadURL(),
                                    builder: (context, snap) {
                                      return CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        imageUrl: snap.data.toString(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data.length,
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.white70,
              ),
              backgroundColor: Colors.blue,
              onPressed: () {},
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'ホーム',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.orange,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
