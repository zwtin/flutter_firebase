import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/sign_in/sign_in_bloc.dart';
import 'package:flutter_firebase/blocs/tab/tab_bloc.dart';
import 'package:flutter_firebase/entities/current_user.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/entities/alert.dart';
import 'package:sweetalert/sweetalert.dart';

class SignInScreen extends StatelessWidget {
  StreamSubscription<int> newRegisterSubscription;

  @override
  Widget build(BuildContext context) {
    final signInBloc = Provider.of<SignInBloc>(context);
    final tabBloc = Provider.of<TabBloc>(context);

    signInBloc.popController.listen(
      (_) {
        Navigator.of(context).pop();
      },
    );

    newRegisterSubscription?.cancel();
    newRegisterSubscription = tabBloc.newRegisterController.stream.listen(
      (int index) {
        Navigator.of(context).pop();
      },
    );

    signInBloc.alertController.stream.listen(
      (Alert alert) {
        SweetAlert.show(
          context,
          title: alert.title,
          subtitle: alert.subtitle,
          style: alert.style,
          showCancelButton: alert.showCancelButton,
          onPress: alert.onPress,
        );
      },
    );

    signInBloc.registerDeviceTokenController.stream.listen(
      (_) {
        tabBloc.registerDeviceTokenController.sink.add(null);
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
                          onPressed: signInBloc.loginWithGoogle,
                        )
                      : RaisedButton(
                          child: const Text('Apple'),
                          color: Colors.orange,
                          textColor: Colors.white,
                          onPressed: signInBloc.loginWithApple,
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
