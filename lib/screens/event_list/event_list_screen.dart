import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_bloc.dart';
import 'package:flutter_firebase/blocs/new_register/new_register_bloc.dart';
import 'package:flutter_firebase/blocs/post_event_bloc/post_event_bloc.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firestore_favorite_repository.dart';
import 'package:flutter_firebase/models/firestore_like_repository.dart';
import 'package:flutter_firebase/models/firestore_user_repository.dart';
import 'package:flutter_firebase/screens/event_detail/event_detail_screen.dart';
import 'package:flutter_firebase/blocs/event_detail/event_detail_bloc.dart';
import 'package:flutter_firebase/models/firestore_item_repository.dart';
import 'package:flutter_firebase/blocs/tab/tab_bloc.dart';
import 'package:flutter_firebase/screens/new_register/new_register_screen.dart';
import 'package:flutter_firebase/screens/post_event_screen/post_event_screen.dart';
import 'package:provider/provider.dart';

class EventListScreen extends StatelessWidget {
  StreamSubscription<int> rootTransitionSubscription;
  StreamSubscription<int> newRegisterSubscription;

  @override
  Widget build(BuildContext context) {
    final eventListBloc = Provider.of<EventListBloc>(context);
    final tabBloc = Provider.of<TabBloc>(context);

    rootTransitionSubscription?.cancel();
    rootTransitionSubscription = tabBloc.rootTransitionController.stream.listen(
      (int index) {
        if (index == 0) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
    );

    newRegisterSubscription?.cancel();
    newRegisterSubscription = tabBloc.newRegisterController.stream.listen(
      (int index) {
        if (index == 0) {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute<NewRegisterScreen>(
              builder: (BuildContext context) {
                return MultiProvider(
                  providers: [
                    Provider<NewRegisterBloc>(
                      create: (BuildContext context) {
                        return NewRegisterBloc(
                          FirebaseAuthenticationRepository(),
                          FirestoreUserRepository(),
                        );
                      },
                      dispose: (BuildContext context, NewRegisterBloc bloc) {
                        bloc.dispose();
                      },
                    ),
                    Provider<TabBloc>.value(value: tabBloc),
                  ],
                  child: NewRegisterScreen(),
                );
              },
              fullscreenDialog: true,
            ),
          );
        }
      },
    );

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
      body: RefreshIndicator(
        onRefresh: eventListBloc.start,
        child: Scrollbar(
          child: StreamBuilder(
            stream: eventListBloc.itemController.stream,
            builder:
                (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<EventDetailScreen>(
                            builder: (BuildContext context) {
                              return Provider<EventDetailBloc>(
                                create: (BuildContext context) {
                                  return EventDetailBloc(
                                    snapshot.data.elementAt(index).id,
                                    FirestoreItemRepository(),
                                    FirestoreLikeRepository(),
                                    FirestoreFavoriteRepository(),
                                    FirebaseAuthenticationRepository(),
                                  );
                                },
                                dispose: (BuildContext context,
                                    EventDetailBloc bloc) {
                                  bloc.dispose();
                                },
                                child: EventDetailScreen(),
                              );
                            },
                          ),
                        );
                      },
                      child: Padding(
                        child: Text(
                          '${snapshot.data.elementAt(index).id}',
                          style: const TextStyle(fontSize: 22),
                        ),
                        padding: const EdgeInsets.all(20),
                      ),
                    ),
                  );
                },
                itemCount: snapshot.hasData ? snapshot.data.length : 0,
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute<PostEventScreen>(
              builder: (BuildContext context) {
                return MultiProvider(
                  providers: [
                    Provider<PostEventBloc>(
                      create: (BuildContext context) {
                        return PostEventBloc(
                          FirestoreUserRepository(),
                          FirebaseAuthenticationRepository(),
                        );
                      },
                      dispose: (BuildContext context, PostEventBloc bloc) {
                        bloc.dispose();
                      },
                    ),
                    Provider<TabBloc>.value(value: tabBloc),
                  ],
                  child: PostEventScreen(),
                );
              },
              fullscreenDialog: true,
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
    );
  }
}
