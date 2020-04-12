import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_bloc.dart';
import 'package:flutter_firebase/blocs/new_register/new_register_bloc.dart';
import 'package:flutter_firebase/entities/item.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firestore_favorite_repository.dart';
import 'package:flutter_firebase/models/firestore_like_repository.dart';
import 'package:flutter_firebase/screens/event_detail/event_detail_screen.dart';
import 'package:flutter_firebase/blocs/event_detail/event_detail_bloc.dart';
import 'package:flutter_firebase/models/firestore_item_repository.dart';
import 'package:flutter_firebase/blocs/tab/tab_bloc.dart';
import 'package:flutter_firebase/screens/new_register/new_register_screen.dart';

class EventListScreen extends StatelessWidget {
  StreamSubscription<int> rootTransitionSubscription;
  StreamSubscription<int> newRegisterSubscription;

  @override
  Widget build(BuildContext context) {
    final eventListBloc = BlocProvider.of<EventListBloc>(context);
    final tabBloc = BlocProvider.of<TabBloc>(context);

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
                return BlocProvider<NewRegisterBloc>(
                  creator: (BuildContext context, BlocCreatorBag bag) {
                    return NewRegisterBloc(
                      FirebaseAuthenticationRepository(),
                    );
                  },
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
                            builder: (context) {
                              return BlocProvider<EventDetailBloc>(
                                creator: (__context, _bag) {
                                  return EventDetailBloc(
                                    snapshot.data.elementAt(index).id,
                                    FirestoreItemRepository(),
                                    FirestoreLikeRepository(),
                                    FirestoreFavoriteRepository(),
                                    FirebaseAuthenticationRepository(),
                                  );
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
                          style: TextStyle(fontSize: 22.0),
                        ),
                        padding: EdgeInsets.all(20.0),
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
    );
  }
}
