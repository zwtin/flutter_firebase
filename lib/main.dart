import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/screens/tab_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/tab/tab_bloc.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned(
    () {
      return runApp(
        MyApp(),
      );
    },
    onError: Crashlytics.instance.recordError,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: BlocProvider<TabBloc>(
        creator: (BuildContext context, BlocCreatorBag bag) {
          return TabBloc();
        },
        child: TabScreen(),
      ),
    );
  }
}
