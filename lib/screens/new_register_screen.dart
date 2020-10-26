import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/new_register_bloc.dart';
import 'package:flutter_firebase/blocs/tab_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_firebase/use_cases/alert.dart';
import 'package:sweetalert/sweetalert.dart';

class NewRegisterScreen extends StatelessWidget {
  StreamSubscription<int> newRegisterSubscription;

  @override
  Widget build(BuildContext context) {
    final newRegisterBloc = Provider.of<NewRegisterBloc>(context);
    final tabBloc = Provider.of<TabBloc>(context);

    newRegisterBloc.popController.listen(
      (_) {
        Navigator.of(context).pop();
      },
    );

    newRegisterSubscription?.cancel();
    newRegisterSubscription = tabBloc.newRegisterController.stream.listen(
      (int index) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );

    newRegisterBloc.alertController.stream.listen(
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

    // 画面
    return StreamBuilder(
      stream: newRegisterBloc.loadingController.stream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return LoadingOverlay(
          child: Scaffold(
            // ナビゲーションバー
            appBar: AppBar(
              title: const Text(
                '新規会員登録',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color(0xFFFFCC00),
              elevation: 0, // 影をなくす
              bottom: PreferredSize(
                child: Container(
                  color: Colors.white24,
                  height: 1,
                ),
                preferredSize: const Size.fromHeight(1),
              ),
            ),

            body: Stack(
              children: [
                Container(
                  color: const Color(0xFFFFCC00),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 32,
                      ),
                      const Center(
                        child: Text(
                          ' ー メールアドレスで新規会員登録 ー ',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      SizedBox(
                        width: 300,
                        height: 44,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: TextField(
                            controller: newRegisterBloc.emailController,
                            readOnly: true,
                            decoration: InputDecoration(
                              //Focusしていないとき
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              //Focusしているとき
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: 'メールアドレス',
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      SizedBox(
                        width: 300,
                        height: 44,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          child: TextField(
                            controller: newRegisterBloc.passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              //Focusしていないとき
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              //Focusしているとき
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: 'パスワード',
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Container(
                        width: 250,
                        height: 44,
                        child: SignInButton(
                          Buttons.Email,
                          text: 'Sign up with Email',
                          mini: false,
                          onPressed:
                              newRegisterBloc.createUserWithEmailAndPassword,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          isLoading: snapshot.data ?? false,
          color: Colors.grey,
        );
      },
    );
  }
}
