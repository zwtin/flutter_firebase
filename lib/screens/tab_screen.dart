import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/profile/profile_bloc.dart';
import 'package:flutter_firebase/blocs/event_list/event_list_bloc.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firestore_item_repository.dart';
import 'package:flutter_firebase/models/firestore_user_repository.dart';
import 'package:flutter_firebase/screens/event_list/event_list_screen.dart';
import 'package:flutter_firebase/screens/profile/profile_screen.dart';
import 'package:flutter_firebase/blocs/tab/tab_bloc.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';

class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tabBloc = BlocProvider.of<TabBloc>(context);

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
            ),
            selectedIndex: indexSnapshot.data ?? 0,
            onSelectTab: (int index) {
              tabBloc.indexController.sink.add(index);
            },
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
                onGenerateRoute: (settings) {
                  return MaterialPageRoute<Widget>(
                    builder: (context) {
                      return BlocProvider<EventListBloc>(
                        creator: (BuildContext context, BlocCreatorBag bag) {
                          return EventListBloc(
                            FirestoreItemRepository(),
                          );
                        },
                        child: EventListScreen(),
                      );
                    },
                  );
                },
              ),
              Navigator(
                onGenerateRoute: (settings) {
                  return MaterialPageRoute<Widget>(
                    builder: (context) {
                      return BlocProvider<ProfileBloc>(
                        creator: (BuildContext context, BlocCreatorBag bag) {
                          return ProfileBloc(
                            FirestoreUserRepository(),
                            FirestoreItemRepository(),
                            FirebaseAuthenticationRepository(),
                          );
                        },
                        child: ProfileScreen(),
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
