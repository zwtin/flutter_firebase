import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/sign_in_bloc.dart';
import 'package:flutter_firebase/blocs/tab_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/use_cases/alert.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

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
        Navigator.of(context).popUntil((route) => route.isFirst);
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

    // 画面
    return StreamBuilder(
      stream: signInBloc.loadingController.stream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return LoadingOverlay(
          child: Scaffold(
            // ナビゲーションバー
            appBar: AppBar(
              title: const Text(
                'ログイン',
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
                          ' ー メールアドレスでログイン ー ',
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
                            controller: signInBloc.emailController,
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
                            controller: signInBloc.passwordController,
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
                          mini: false,
                          onPressed: signInBloc.loginWithEmailAndPassword,
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          const Text(
                            'パスワードを忘れた方は',
                            style: TextStyle(color: Colors.white),
                          ),
                          InkWell(
                            child: const Text(
                              'こちら',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {},
                          ),
                          const Spacer(),
                        ],
                      ),
                      Container(
                        height: 32,
                      ),
                      const Center(
                        child: Text(
                          ' ー SNSアカウントでログイン ー ',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Container(
                        width: 250,
                        height: 44,
                        child: SignInButton(
                          Buttons.Google,
                          mini: false,
                          onPressed: signInBloc.loginWithGoogle,
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Container(
                        width: 250,
                        height: 44,
                        child: SignInButton(
                          Buttons.AppleDark,
                          mini: false,
                          onPressed: signInBloc.loginWithApple,
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Container(
                        width: 250,
                        height: 44,
                        child: SignInButton(
                          Buttons.Twitter,
                          mini: false,
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Container(
                        width: 250,
                        height: 44,
                        child: SignInButton(
                          Buttons.Facebook,
                          mini: false,
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        height: 16,
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
