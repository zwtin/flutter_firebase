import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/sign_up/sign_up_bloc.dart';
import 'package:flutter_firebase/blocs/tab/tab_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  StreamSubscription<int> newRegisterSubscription;

  @override
  Widget build(BuildContext context) {
    final signUpBloc = Provider.of<SignUpBloc>(context);
    final tabBloc = Provider.of<TabBloc>(context);

    newRegisterSubscription?.cancel();
    newRegisterSubscription = tabBloc.newRegisterController.stream.listen(
      (int index) {
        Navigator.of(context).pop();
      },
    );

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
                          onPressed: signUpBloc.signUpWithGoogle,
                        )
                      : RaisedButton(
                          child: const Text('Apple'),
                          color: Colors.orange,
                          textColor: Colors.white,
                          onPressed: signUpBloc.signUpWithApple,
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
