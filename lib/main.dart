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
  int currentIndex = 0;
  int tap = 0;

  Widget tab1 = Scaffold(
    body: Center(
      child: Text('aaa'),
    ),
    floatingActionButton: FloatingActionButton(),
  );

  Widget tab2 = MaterialApp(
    home: CalcBlocProvider(
      child: CalcScreen(),
    ),
  );

  final List<Tab> tabs = <Tab>[
    Tab(
      icon: Icon(Icons.home),
    ),
    Tab(
      icon: Icon(Icons.person),
    ),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    tap = 0;
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
        onTap: (index) {
          switch (index) {
            case 0:
              currentIndex = 0;
              break;
            case 1:
              currentIndex = 1;
              break;
          }
        },
        activeColor: Colors.blue,
        inactiveColor: Colors.black,
        backgroundColor: Colors.red,
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            switch (currentIndex) {
              case 0:
                return tab1;
                break;
              case 1:
                return tab2;
                break;
            }
            return Scaffold();
          },
        );
      },
    );
  }
}
