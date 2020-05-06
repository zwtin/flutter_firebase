import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/screens/tab_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_firebase/blocs/tab_bloc.dart';
import 'package:provider/provider.dart';

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
      home: Provider<TabBloc>(
        create: (BuildContext context) {
          return TabBloc();
        },
        dispose: (BuildContext context, TabBloc bloc) {
          bloc.dispose();
        },
        child: TabScreen(),
      ),
    );
  }
}
