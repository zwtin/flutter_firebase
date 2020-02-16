import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_repository.dart';
import 'package:flutter_firebase/repositories/firebase_authentication_repository.dart';

import 'package:flutter_firebase/screens/sign_in_screen.dart';
import 'package:flutter_firebase/screens/event_list_screen.dart';

import 'package:flutter_firebase/CalcSample/calc_provider.dart';
import 'package:flutter_firebase/CalcSample/screen.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned(() {
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final CupertinoTabController _cupertinoTabController =
      CupertinoTabController();

  @override
  void initState() {
    super.initState();
  }

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
                return MaterialApp(
                  home: CalcBlocProvider(
                    child: CalcScreen(),
                  ),
                );
                break;
            }
            return Scaffold();
          },
        );
      },
    );
  }
}
