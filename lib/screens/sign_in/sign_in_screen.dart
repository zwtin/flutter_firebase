import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/sign_in/sign_in_state.dart';
import 'package:flutter_firebase/blocs/sign_in/sign_in_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/profile/profile_bloc.dart';
import 'package:flutter_firebase/blocs/sign_up/sign_up_bloc.dart';
import 'package:flutter_firebase/models/firebase_authentication_repository.dart';
import 'package:flutter_firebase/models/firestore_user_repository.dart';
import 'package:flutter_firebase/screens/profile/profile_screen.dart';
import 'package:flutter_firebase/screens/sign_up/sign_up_screen.dart';
import 'package:flutter_firebase/blocs/tab/tab_bloc.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signInBloc = BlocProvider.of<SignInBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'マイページ',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('メール'),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: signInBloc.emailController,
              ),
            ),
            const Text('パスワード'),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: signInBloc.passwordController,
              ),
            ),
            RaisedButton(
              child: const Text('ログイン'),
              color: Colors.orange,
              textColor: Colors.white,
              onPressed: signInBloc.loginWithEmailAndPassword,
            ),
            Platform.isAndroid
                ? RaisedButton(
                    child: const Text('Google'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () {},
                  )
                : RaisedButton(
                    child: const Text('Apple'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
            RaisedButton(
              child: const Text('Twitter'),
              color: Colors.orange,
              textColor: Colors.white,
              onPressed: () {},
            ),
            RaisedButton(
              child: const Text('Facebook'),
              color: Colors.orange,
              textColor: Colors.white,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );

//    return StreamBuilder<SignInState>(
//      stream: signInBloc.screenState,
//      builder: (context, snapshot) {
//        if (snapshot.hasData && snapshot.data is SignInInProgress) {
//          return Scaffold(
//            appBar: AppBar(
//              title: Text(
//                'マイページ',
//                style: TextStyle(
//                  color: Colors.white,
//                ),
//              ),
//              backgroundColor: Colors.orange,
//            ),
//            body: const Center(
//              child: CircularProgressIndicator(),
//            ),
//          );
//        } else if (snapshot.hasData && snapshot.data is SignInFailure) {
//          return Scaffold(
//            appBar: AppBar(
//              title: Text(
//                'マイページ',
//                style: TextStyle(
//                  color: Colors.white,
//                ),
//              ),
//              backgroundColor: Colors.orange,
//            ),
//            body: Center(
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  const Text('読み込みに失敗しました'),
//                  RaisedButton(
//                    child: const Text('再読み込み'),
//                    color: Colors.orange,
//                    textColor: Colors.white,
//                    onPressed: signInBloc.checkCurrentUser,
//                  ),
//                ],
//              ),
//            ),
//          );
//        } else if (snapshot.hasData && snapshot.data is SignInSuccess) {
//          final user = (snapshot.data as SignInSuccess).currentUser;
//          if (user == null) {
//            return Scaffold(
//              appBar: AppBar(
//                title: Text(
//                  'マイページ',
//                  style: TextStyle(
//                    color: Colors.white,
//                  ),
//                ),
//                backgroundColor: Colors.orange,
//              ),
//              body: Center(
//                child: Column(
//                  mainAxisSize: MainAxisSize.min,
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    const Text('メール'),
//                    Padding(
//                      padding: const EdgeInsets.all(16),
//                      child: TextField(
//                        onChanged: (String str) {
//                          signInBloc.inputEmail = str;
//                        },
//                        onSubmitted: (String str) {
//                          signInBloc.inputEmail = str;
//                        },
//                      ),
//                    ),
//                    const Text('パスワード'),
//                    Padding(
//                      padding: const EdgeInsets.all(16),
//                      child: TextField(
//                        onChanged: (String str) {
//                          signInBloc.inputPassword = str;
//                        },
//                        onSubmitted: (String str) {
//                          signInBloc.inputPassword = str;
//                        },
//                      ),
//                    ),
//                    RaisedButton(
//                      child: const Text('ログイン'),
//                      color: Colors.orange,
//                      textColor: Colors.white,
//                      onPressed: signInBloc.loginWithEmailAndPassword,
//                    ),
//                    Platform.isAndroid
//                        ? RaisedButton(
//                            child: const Text('Google'),
//                            color: Colors.orange,
//                            textColor: Colors.white,
//                            onPressed: signInBloc.loginWithEmailAndPassword,
//                          )
//                        : RaisedButton(
//                            child: const Text('Apple'),
//                            color: Colors.orange,
//                            textColor: Colors.white,
//                            onPressed: signInBloc.loginWithEmailAndPassword,
//                          ),
//                    RaisedButton(
//                      child: const Text('Twitter'),
//                      color: Colors.orange,
//                      textColor: Colors.white,
//                      onPressed: signInBloc.loginWithEmailAndPassword,
//                    ),
//                    RaisedButton(
//                      child: const Text('Facebook'),
//                      color: Colors.orange,
//                      textColor: Colors.white,
//                      onPressed: signInBloc.loginWithEmailAndPassword,
//                    ),
//                    RaisedButton(
//                      child: const Text('新規会員登録はこちら'),
//                      color: Colors.orange,
//                      textColor: Colors.white,
//                      onPressed: () {
//                        Navigator.of(context, rootNavigator: true).push(
//                          MaterialPageRoute<SignUpScreen>(
//                            builder: (context) => BlocProvider<SignUpBloc>(
//                              creator: (_context, _bag) {
//                                return SignUpBloc(
//                                  FirebaseAuthenticationRepository(),
//                                );
//                              },
//                              child: SignUpScreen(),
//                            ),
//                            fullscreenDialog: true,
//                          ),
//                        );
//                      },
//                    ),
//                  ],
//                ),
//              ),
//            );
//          }
//          return BlocProvider<ProfileBloc>(
//            creator: (_context, _bag) {
//              return ProfileBloc(
//                FirestoreUserRepository(),
//                FirebaseAuthenticationRepository(),
//              );
//            },
//            child: ProfileScreen(signInBloc),
//          );
//        } else {
//          return Scaffold(
//            appBar: AppBar(
//              title: Text(
//                'マイページ',
//                style: TextStyle(
//                  color: Colors.white,
//                ),
//              ),
//              backgroundColor: Colors.orange,
//            ),
//            body: const Center(
//              child: CircularProgressIndicator(),
//            ),
//          );
//        }
//      },
//    );
  }
}
