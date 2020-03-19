import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/sign_in/sign_in_bloc.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_bloc.dart';
import 'package:flutter_firebase/repositories/firebase_authentication_repository.dart';
import 'package:flutter_firebase/repositories/firebase_storage_repository.dart';
import 'package:flutter_firebase/repositories/firestore_event_list_repository.dart';
import 'package:flutter_firebase/screens/event_list/event_list_screen.dart';
import 'package:flutter_firebase/screens/sign_in/sign_in_screen.dart';

class TabScreen extends StatelessWidget {
  final CupertinoTabController _cupertinoTabController =
      CupertinoTabController();

  @override
  Widget build(BuildContext context) {
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
              builder: (context) {
                return BlocProvider<EventListBloc>(
                  creator: (_context, _bag) {
                    return EventListBloc(
                      FirestoreEventListRepository(),
                      FirebaseStorageRepository(),
                    );
                  },
                  child: EventListScreen(),
                );
              },
            );
            break;
          case 1:
            return CupertinoTabView(
              builder: (context) {
                return BlocProvider<SignInBloc>(
                  creator: (_context, _bag) {
                    return SignInBloc(
                      FirebaseAuthenticationRepository(),
                    );
                  },
                  child: SignInScreen(),
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
