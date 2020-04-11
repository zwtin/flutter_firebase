import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/new_register/new_register_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/entities/current_user.dart';
import 'package:loading_overlay/loading_overlay.dart';

class NewRegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newRegisterBloc = BlocProvider.of<NewRegisterBloc>(context);

    newRegisterBloc.currentUserController.listen(
      (CurrentUser currentUser) {
        if (currentUser != null) {
          Navigator.of(context).pop();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NewRegisterScreen',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder(
        stream: newRegisterBloc.loadingController.stream,
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
                      controller: newRegisterBloc.emailController,
                    ),
                  ),
                  const Text('パスワード'),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: newRegisterBloc.passwordController,
                    ),
                  ),
                  RaisedButton(
                    child: const Text('ログイン'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: newRegisterBloc.loginWithEmailAndPassword,
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
