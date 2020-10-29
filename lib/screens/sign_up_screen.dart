import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/sent_register_email_bloc.dart';
import 'package:flutter_firebase/blocs/sign_up_bloc.dart';
import 'package:flutter_firebase/blocs/tab_bloc.dart';
import 'package:flutter_firebase/screens/sent_register_email_screen.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/use_cases/alert.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:flutter_firebase/use_cases/current_user.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignUpScreen extends StatelessWidget {
  StreamSubscription<int> newRegisterSubscription;

  @override
  Widget build(BuildContext context) {
    final signUpBloc = Provider.of<SignUpBloc>(context);
    final tabBloc = Provider.of<TabBloc>(context);

    newRegisterSubscription?.cancel();
    newRegisterSubscription = tabBloc.newRegisterController.stream.listen(
      (int index) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );

    signUpBloc.popController.listen(
      (_) {
        Navigator.of(context).pop();
      },
    );

    signUpBloc.sentRegisterEmailController.listen(
      (_) {
        Navigator.of(context).push(
          MaterialPageRoute<SentRegisterEmailScreen>(
            builder: (BuildContext context) {
              return Provider<SentRegisterEmailBloc>(
                create: (BuildContext context) {
                  return SentRegisterEmailBloc();
                },
                dispose: (BuildContext context, SentRegisterEmailBloc bloc) {
                  bloc.dispose();
                },
                child: SentRegisterEmailScreen(),
              );
            },
          ),
        );
      },
    );

    signUpBloc.alertController.stream.listen(
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
      stream: signUpBloc.loadingController.stream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return LoadingOverlay(
          child: Scaffold(
            // ナビゲーションバー
            appBar: AppBar(
              title: const Text(
                '新規登録',
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
                          ' ー メールアドレスで新規登録 ー ',
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
                            controller: signUpBloc.emailController,
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
                      Container(
                        width: 250,
                        height: 44,
                        child: SignInButton(
                          Buttons.Email,
                          text: 'Send Email To Confirm',
                          mini: false,
                          onPressed: signUpBloc.sendSignInWithEmailLink,
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          InkWell(
                            child: const Text(
                              '利用規約',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {},
                          ),
                          const Text(
                            'に同意の上ご登録ください',
                            style: TextStyle(color: Colors.white),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Container(
                        height: 32,
                      ),
                      const Center(
                        child: Text(
                          ' ー SNSアカウントで新規登録 ー ',
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
                          onPressed: signUpBloc.signUpWithGoogle,
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
                          onPressed: signUpBloc.signUpWithApple,
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
