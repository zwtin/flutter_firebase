import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_event.dart';
import 'package:flutter_firebase/blocs/sign_in/sign_in_bloc.dart';
import 'package:flutter_firebase/blocs/sign_in/sign_in_event.dart';
import 'package:flutter_firebase/blocs/sign_in/sing_in_state.dart';
import 'package:flutter_firebase/repositories/firebase_sign_in_repository.dart';

class SignInScreen extends StatelessWidget {
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final signInBloc = SignInBloc(signInRepository: FirebaseSignInRepository());
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: BlocBuilder<SignInBloc, SignInState>(
          bloc: signInBloc,
          builder: (context, state) {
            if (state is SignInLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is SignInSuccess) {
              return Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Success"),
                  RaisedButton(
                    onPressed: () {
                      authenticationBloc.add(LoggedIn());
                    },
                    child: Text('StartApp'),
                  )
                ],
              ));
            }

            if (state is SignInFailure) {
              return Center(
                child: Text("Failure"),
              );
            }

            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                    child: Column(
                      children: <Widget>[
                        Text('メールアドレス'),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Mail',
                          ),
                          controller: _mailController,
                        ),
                        Text('パスワード'),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                          controller: _passwordController,
                        )
                      ],
                    ),
                  ),
                  RaisedButton.icon(
                      onPressed: () {
                        signInBloc.add(SignInWithEmailAndPasswordOnPressed(
                            email: _mailController.text,
                            password: _passwordController.text));
                      },
                      icon: Icon(Icons.mail_outline),
                      label: Text("Mail Login")),
                  RaisedButton.icon(
                      onPressed: () {
                        signInBloc.add(SignInAnonymouslyOnPressed());
                      },
                      icon: Icon(Icons.account_circle),
                      label: Text("Guest Login")),
                  RaisedButton.icon(
                      onPressed: () {
                        signInBloc.add(SignInWithGoogleOnPressed());
                      },
                      icon: Icon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                      ),
                      label: Text("Login With Google",
                          style: TextStyle(color: Colors.white)))
                ],
              ),
            );
          }),
    );
  }
}
