import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/sign_in/sign_in_bloc.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_bloc.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firebase_storage_repository.dart';
import 'package:flutter_firebase/models/firestore_event_repository.dart';
import 'package:flutter_firebase/screens/event_list/event_list_screen.dart';
import 'package:flutter_firebase/screens/sign_in/sign_in_screen.dart';
import 'package:flutter_firebase/blocs/tab/tab_bloc.dart';

class TabScreen extends StatelessWidget {
  final CupertinoTabController _cupertinoTabController =
      CupertinoTabController();

  @override
  Widget build(BuildContext context) {
    final tabBloc = BlocProvider.of<TabBloc>(context);

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
          ),
        ],
        activeColor: Colors.blue,
        inactiveColor: Colors.white,
        backgroundColor: Colors.orange,
      ),
      controller: _cupertinoTabController,
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return BlocProvider<EventListBloc>(
                  creator: (BuildContext context, BlocCreatorBag bag) {
                    return EventListBloc(
                      FirestoreEventRepository(),
                      FirebaseStorageRepository(),
                    );
                  },
                  child: EventListScreen(tabBloc),
                );
              },
            );
            break;
          case 1:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return BlocProvider<SignInBloc>(
                  creator: (BuildContext context, BlocCreatorBag bag) {
                    return SignInBloc(
                      FirebaseAuthenticationRepository(),
                    );
                  },
                  child: SignInScreen(tabBloc),
                );
              },
            );
            break;
        }
        return const CupertinoTabView();
      },
    );
  }
}
