import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/blocs/new_register_bloc.dart';
import 'package:flutter_firebase/blocs/profile_bloc.dart';
import 'package:flutter_firebase/blocs/event_list_bloc.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firestore_item_repository.dart';
import 'package:flutter_firebase/models/firestore_user_repository.dart';
import 'package:flutter_firebase/screens/event_list_screen.dart';
import 'package:flutter_firebase/screens/new_register_screen.dart';
import 'package:flutter_firebase/screens/profile_screen.dart';
import 'package:flutter_firebase/blocs/tab_bloc.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:provider/provider.dart';

class TabScreen extends StatelessWidget {
  final EventListScreen _eventListScreen = EventListScreen();
  final ProfileScreen _profileScreen = ProfileScreen();

  @override
  Widget build(BuildContext context) {
    final tabBloc = Provider.of<TabBloc>(context);

    return WillPopScope(
      onWillPop: () {
        tabBloc.pop();
        return Future.value(false);
      },
      child: StreamBuilder(
        stream: tabBloc.indexController.stream,
        builder: (BuildContext context, AsyncSnapshot<int> indexSnapshot) {
          return Scaffold(
            bottomNavigationBar: FFNavigationBar(
              theme: FFNavigationBarTheme(
                barBackgroundColor: Colors.black87,
                selectedItemBackgroundColor: const Color(0xFFFFCC00),
                selectedItemLabelColor: Colors.white,
                selectedItemBorderColor: Colors.yellow,
                unselectedItemIconColor: Colors.grey,
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
                tabBloc.tab0,
                tabBloc.tab1,
              ],
            ),
          );
        },
      ),
    );
  }
}
