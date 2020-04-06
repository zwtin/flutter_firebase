import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/sign_in/sign_in_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/entities/current_user.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signInBloc = BlocProvider.of<SignInBloc>(context);

    signInBloc.currentUserController.listen(
      (CurrentUser currentUser) {
        if (currentUser != null) {
          Navigator.of(context).pop();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ログイン',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder(
        stream: signInBloc.loadingController.stream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return LoadingOverlay(
            child: Center(
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
            isLoading: snapshot.data ?? false,
            color: Colors.grey,
          );
        },
      ),
    );
  }
}
