import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_event.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_state.dart';
import 'package:flutter_firebase/repositories/firebase_authentication_repository.dart';
import 'package:flutter_firebase/screens/event_list_screen.dart';
import 'package:flutter_firebase/screens/sign_in_screen.dart';
import 'package:flutter_firebase/screens/splash_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {
  final authenticationRepository = FirebaseAuthenticationRepository();
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned(() {
    runApp(
      BlocProvider<AuthenticationBloc>(
        create: (context) =>
            AuthenticationBloc(authRepository: authenticationRepository)
              ..add(AppStarted()),
        child: MyApp(),
      ),
    );
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    return MaterialApp(
      title: 'Awase',
      theme: ThemeData(
          primaryColor: Colors.indigo[900],
          accentColor: Colors.pink[800],
          brightness: Brightness.light),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          bloc: authenticationBloc,
          builder: (context, state) {
            if (state is AuthenticationInProgress) {
              return SplashScreen();
            }
            if (state is AuthenticationSuccess) {
              return EventListScreen(authenticationBloc: authenticationBloc);
            }
            if (state is AuthenticationFailure) {
              return SignInScreen();
            }
            return Container();
          }),
    );
  }
}
