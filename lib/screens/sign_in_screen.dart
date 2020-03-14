import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_state.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/blocs/profile/profile_bloc.dart';
import 'package:flutter_firebase/repositories/firestore_user_repository.dart';
import 'package:flutter_firebase/screens/profile_screen.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return StreamBuilder<AuthenticationState>(
      stream: authenticationBloc.screenState,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is AuthenticationInProgress) {
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
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData && snapshot.data is AuthenticationFailure) {
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
                  const Text('読み込みに失敗しました'),
                  RaisedButton(
                    child: const Text('再読み込み'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: authenticationBloc.checkCurrentUser,
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasData && snapshot.data is AuthenticationSuccess) {
          final user = (snapshot.data as AuthenticationSuccess).currentUser;
          if (user == null) {
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
                        onChanged: (String str) {
                          authenticationBloc.inputEmail = str;
                        },
                        onSubmitted: (String str) {
                          authenticationBloc.inputEmail = str;
                        },
                      ),
                    ),
                    const Text('パスワード'),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        onChanged: (String str) {
                          authenticationBloc.inputPassword = str;
                        },
                        onSubmitted: (String str) {
                          authenticationBloc.inputPassword = str;
                        },
                      ),
                    ),
                    RaisedButton(
                      child: const Text('ログイン'),
                      color: Colors.orange,
                      textColor: Colors.white,
                      onPressed: authenticationBloc.loginWithEmailAndPassword,
                    ),
                  ],
                ),
              ),
            );
          }
          return BlocProvider<ProfileBloc>(
            creator: (_context, _bag) {
              return ProfileBloc(
                user.id,
                FirestoreUserRepository(),
              );
            },
            child: ProfileScreen(authenticationBloc),
          );
        } else {
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
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
