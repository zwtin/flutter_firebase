import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/sign_up/sign_up_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final signUpBloc = BlocProvider.of<SignUpBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '新規会員登録',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder(
        stream: signUpBloc.loadingController.stream,
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
                      controller: signUpBloc.emailController,
                    ),
                  ),
                  RaisedButton(
                    child: const Text('メール送信'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: signUpBloc.sendSignInWithEmailLink,
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
