import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_state.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return StreamBuilder<AuthenticationState>(
      stream: authenticationBloc.onAdd,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == AuthenticationInProgress()) {
          return const Center(
            child: Text('a'),
          );
        } else {
          return const Center(
            child: Text('b'),
          );
        }
      },
    );
  }
}
