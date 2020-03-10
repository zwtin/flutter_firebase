import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_state.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';

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
          final _mailController = TextEditingController();
          final _passwordController = TextEditingController();
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
                      controller: _mailController,
                    ),
                  ),
                  const Text('パスワード'),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _passwordController,
                    ),
                  ),
                  RaisedButton(
                    child: const Text('ログイン'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_mailController.text.isEmpty) {
                        return;
                      }
                      if (_passwordController.text.isEmpty) {
                        return;
                      }
                      authenticationBloc.loginWithMailAndPassword(
                        _mailController.text,
                        _passwordController.text,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasData && snapshot.data is AuthenticationSuccess) {
          final user = (snapshot.data as AuthenticationSuccess).currentUser;
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
                  Text(user.id),
                  RaisedButton(
                    child: const Text('ログアウト'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: authenticationBloc.signOut,
                  ),
                ],
              ),
            ),
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
