import 'package:flutter/material.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter_firebase/screens/sign_up/sign_up_screen.dart';
import 'package:flutter_firebase/blocs/sign_up/sign_up_bloc.dart';
import 'package:flutter_firebase/repositories/firebase_authentication_repository.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabBloc implements Bloc {
  TabBloc(this.context) : assert(context != null) {
    initDynamicLinks();
  }
  final BuildContext context;

  void openNewRegister() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<SignUpScreen>(
        builder: (context) => BlocProvider<SignUpBloc>(
          creator: (_context, _bag) {
            return SignUpBloc(
              FirebaseAuthenticationRepository(),
            );
          },
          child: SignUpScreen(),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> initDynamicLinks() async {
    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = data?.link;

    if (deepLink != null) {
      print(deepLink.path);
    }

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final deepLink = dynamicLink?.link;

        if (deepLink != null) {
          final query = deepLink.queryParameters;
          final apiKey = query['apiKey'];
          final mode = query['mode'];
          final oobCode = query['oobCode'];

          final prefs = await SharedPreferences.getInstance();
          final inputEmail = prefs.getString('email');
          if (inputEmail != null) {
            openNewRegister();
          }
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      },
    );
  }

  @override
  Future<void> dispose() async {}
}
