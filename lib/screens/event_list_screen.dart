import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/blocs/event_list_bloc.dart';
import 'package:flutter_firebase/blocs/new_register_bloc.dart';
import 'package:flutter_firebase/blocs/post_category_select_bloc.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firestore_favorite_repository.dart';
import 'package:flutter_firebase/models/firestore_like_repository.dart';
import 'package:flutter_firebase/models/firestore_push_notification_repository.dart';
import 'package:flutter_firebase/models/firestore_user_repository.dart';
import 'package:flutter_firebase/screens/event_detail_screen.dart';
import 'package:flutter_firebase/blocs/event_detail_bloc.dart';
import 'package:flutter_firebase/models/firestore_item_repository.dart';
import 'package:flutter_firebase/blocs/tab_bloc.dart';
import 'package:flutter_firebase/screens/new_register_screen.dart';
import 'package:flutter_firebase/screens/post_category_select_screen.dart';
import 'package:flutter_firebase/screens/post_event_screen.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventListBloc = Provider.of<EventListBloc>(context);
    final tabBloc = Provider.of<TabBloc>(context);

    eventListBloc.rootTransitionSubscription?.cancel();
    eventListBloc.rootTransitionSubscription =
        tabBloc.rootTransitionController.stream.listen(
      (int index) {
        if (index == 0) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
    );

    eventListBloc.popTransitionSubscription?.cancel();
    eventListBloc.popTransitionSubscription =
        tabBloc.popTransitionController.stream.listen(
      (int index) {
        if (index == 0) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            SystemNavigator.pop();
          }
        }
      },
    );

    eventListBloc.newRegisterSubscription?.cancel();
    eventListBloc.newRegisterSubscription =
        tabBloc.newRegisterController.stream.listen(
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
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFFFCC00),
        elevation: 0,
        bottom: PreferredSize(
          child: Container(
            color: Colors.white24,
            height: 1,
          ),
          preferredSize: const Size.fromHeight(1),
        ),
      ),
      body: RefreshIndicator(
        color: const Color(0xFFFFCC00),
        onRefresh: eventListBloc.start,
        child: Scrollbar(
          child: StreamBuilder(
            stream: eventListBloc.itemController.stream,
            builder:
                (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
              return Container(
                color: const Color(0xFFFFCC00),
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
                                    child:
                                        Image.asset('assets/icon/no_user.jpg'),
                                  ),
                                ),
                                const Text('〇〇さんからのお題：'),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
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
                            snapshot.data.elementAt(index).imageUrl.isEmpty
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.all(16),
                                    child:
                                        Image.asset('assets/icon/no_image.jpg'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute<PostEventScreen>(
              builder: (BuildContext context) {
                return MultiProvider(
                  providers: [
                    Provider<PostCategorySelectBloc>(
                      create: (BuildContext context) {
                        return PostCategorySelectBloc();
                      },
                      dispose:
                          (BuildContext context, PostCategorySelectBloc bloc) {
                        bloc.dispose();
                      },
                    ),
                    Provider<TabBloc>.value(value: tabBloc),
                  ],
                  child: PostCategorySelectScreen(),
                );
              },
              fullscreenDialog: true,
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: const Color(0xFFFFCC00),
        foregroundColor: Colors.white,
      ),
    );
  }
}
