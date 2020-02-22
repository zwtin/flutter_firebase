import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_firebase/repositories/firebase_authentication_repository.dart';
import 'package:flutter_firebase/screens/sign_in_screen.dart';

class TabScreen extends StatelessWidget {
  final CupertinoTabController _cupertinoTabController =
      CupertinoTabController();

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
          ),
        ],
        activeColor: Colors.blue,
        inactiveColor: Colors.black,
        backgroundColor: Colors.red,
      ),
      controller: _cupertinoTabController,
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                return Center(
                  child: CupertinoButton(
                    child: const Text('Go to first tab'),
                    onPressed: () {
                      _cupertinoTabController.index = 1;
                    },
                  ),
                );
                break;
              case 1:
                return BlocProvider<AuthenticationBloc>(
                  creator: (_context, _bag) {
                    return AuthenticationBloc(
                        FirebaseAuthenticationRepository());
                  },
                  child: SignInScreen(),
                );
            }
            return const Scaffold();
          },
        );
      },
    );
  }
}
