import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/blocs/new_register/new_register_bloc.dart';
import 'package:flutter_firebase/blocs/profile/profile_bloc.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_bloc.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firestore_item_repository.dart';
import 'package:flutter_firebase/models/firestore_user_repository.dart';
import 'package:flutter_firebase/screens/event_list/event_list_screen.dart';
import 'package:flutter_firebase/screens/new_register/new_register_screen.dart';
import 'package:flutter_firebase/screens/profile/profile_screen.dart';
import 'package:flutter_firebase/blocs/tab/tab_bloc.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:provider/provider.dart';

class TabScreen extends StatelessWidget {
  final EventListScreen _eventListScreen = EventListScreen();
  final ProfileScreen _profileScreen = ProfileScreen();

  @override
  Widget build(BuildContext context) {
    final tabBloc = Provider.of<TabBloc>(context);

    return StreamBuilder(
      stream: tabBloc.indexController.stream,
      builder: (BuildContext context, AsyncSnapshot<int> indexSnapshot) {
        return Scaffold(
          bottomNavigationBar: FFNavigationBar(
            theme: FFNavigationBarTheme(
              barBackgroundColor: Colors.white,
              selectedItemBackgroundColor: Colors.orange,
              selectedItemIconColor: Colors.white,
              selectedItemLabelColor: Colors.black,
              showSelectedItemShadow: false,
            ),
            selectedIndex: indexSnapshot.data ?? 0,
            onSelectTab: tabBloc.tabTappedAction,
            items: [
              FFNavigationBarItem(
                iconData: Icons.home,
                label: 'ホーム',
              ),
              FFNavigationBarItem(
                iconData: Icons.person,
                label: 'マイページ',
              ),
            ],
          ),
          body: IndexedStack(
            index: indexSnapshot.data ?? 0,
            children: <Widget>[
              Navigator(
                onGenerateRoute: (RouteSettings settings) {
                  return PageRouteBuilder<Widget>(
                    pageBuilder: (BuildContext context,
                        Animation<double> animation1,
                        Animation<double> animation2) {
                      return Provider<EventListBloc>(
                        create: (BuildContext context) {
                          return EventListBloc(
                            FirestoreItemRepository(),
                          );
                        },
                        dispose: (BuildContext context, EventListBloc bloc) {
                          bloc.dispose();
                        },
                        child: _eventListScreen,
                      );
                    },
                  );
                },
              ),
              Navigator(
                onGenerateRoute: (RouteSettings settings) {
                  return PageRouteBuilder<Widget>(
                    pageBuilder: (BuildContext context,
                        Animation<double> animation1,
                        Animation<double> animation2) {
                      return Provider<ProfileBloc>(
                        create: (BuildContext context) {
                          return ProfileBloc(
                            FirestoreUserRepository(),
                            FirestoreItemRepository(),
                            FirebaseAuthenticationRepository(),
                          );
                        },
                        dispose: (BuildContext context, ProfileBloc bloc) {
                          bloc.dispose();
                        },
                        child: _profileScreen,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
