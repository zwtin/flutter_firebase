import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/new_register_bloc.dart';
import 'package:flutter_firebase/blocs/tab_bloc.dart';
import 'package:flutter_firebase/use_cases/current_user.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class NewRegisterScreen extends StatelessWidget {
  StreamSubscription<int> newRegisterSubscription;

  @override
  Widget build(BuildContext context) {
    final newRegisterBloc = Provider.of<NewRegisterBloc>(context);
    final tabBloc = Provider.of<TabBloc>(context);

    newRegisterBloc.currentUserController.listen(
      (CurrentUser currentUser) {
        if (currentUser != null) {
          Navigator.of(context).pop();
        }
      },
    );

    newRegisterSubscription?.cancel();
    newRegisterSubscription = tabBloc.newRegisterController.stream.listen(
      (int index) {
        Navigator.of(context).popUntil((route) => route.isFirst);
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
                      readOnly: true,
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
                    child: const Text('アカウント登録'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: newRegisterBloc.createUserWithEmailAndPassword,
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
