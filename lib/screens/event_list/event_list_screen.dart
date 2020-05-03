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
import 'package:flutter_firebase/models/firestore_push_notification_repository.dart';
import 'package:flutter_firebase/models/firestore_user_repository.dart';
import 'package:flutter_firebase/screens/event_detail/event_detail_screen.dart';
import 'package:flutter_firebase/blocs/event_detail/event_detail_bloc.dart';
import 'package:flutter_firebase/models/firestore_item_repository.dart';
import 'package:flutter_firebase/blocs/tab/tab_bloc.dart';
import 'package:flutter_firebase/screens/new_register/new_register_screen.dart';
import 'package:flutter_firebase/screens/post_event_screen/post_event_screen.dart';
import 'package:provider/provider.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                          FirestorePushNotificationRepository(),
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
      body: StreamBuilder(
        stream: eventListBloc.loadingController.stream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return LoadingOverlay(
            child: RefreshIndicator(
              onRefresh: eventListBloc.start,
              child: Scrollbar(
                child: StreamBuilder(
                  stream: eventListBloc.itemController.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Item>> snapshot) {
                    return Container(
                      color: Colors.green,
                      child: ListView.builder(
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      ClipOval(
                                        child: SizedBox(
                                          width: 44,
                                          height: 44,
                                          child: Image.asset(
                                              'assets/icon/no_user.jpg'),
                                        ),
                                      ),
                                      Text('〇〇さんからのお題：'),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        snapshot.data.elementAt(index).title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                  snapshot.data
                                          .elementAt(index)
                                          .imageUrl
                                          .isEmpty
                                      ? Container()
                                      : Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Image.asset(
                                              'assets/icon/no_image.jpg'),
                                        ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot.hasData ? snapshot.data.length : 0,
                      ),
                    );
                  },
                ),
              ),
            ),
            isLoading: snapshot.data ?? false,
            color: Colors.grey,
          );
        },
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
                          FirebaseAuthenticationRepository(),
                          FirestoreItemRepository(),
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
