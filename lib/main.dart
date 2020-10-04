import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/screens/tab_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_firebase/blocs/tab_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  // デッバグ時もクラッシュログを送る
  Crashlytics.instance.enableInDevMode = true;

  // FatalでないFlutterのエラーも送る
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  // MyAppを起動
  runZoned(
    () {
      return runApp(
        MyApp(),
      );
    },

    // エラー時はCrashlyticsにログを送る
    onError: Crashlytics.instance.recordError,
  );
}

// MyAppの定義
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 中身はProvider
      home: Provider<TabBloc>(
        // TabBlocを提供
        create: (BuildContext context) {
          return TabBloc();
        },

        // 画面廃棄時
        dispose: (BuildContext context, TabBloc bloc) {
          bloc.dispose();
        },

        // 表示画面
        child: TabScreen(),
      ),
    );
  }
}
