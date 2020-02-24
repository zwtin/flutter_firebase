import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_state.dart';
import 'package:flutter_firebase/blocs/authentication/authentication_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_admob/firebase_admob.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen() {
    if (Platform.isAndroid) {
      myBanner = BannerAd(
        adUnitId: 'ca-app-pub-6316701082348182~6132425552',
        size: AdSize.smartBanner,
        targetingInfo: const MobileAdTargetingInfo(
          keywords: <String>['flutterio', 'beautiful apps'],
          contentUrl: 'https://flutter.io',
          childDirected: false,
        ),
      );
    } else if (Platform.isIOS) {
      myBanner = BannerAd(
        adUnitId: 'ca-app-pub-6316701082348182~4791423725',
        size: AdSize.smartBanner,
        targetingInfo: const MobileAdTargetingInfo(
          keywords: <String>['flutterio', 'beautiful apps'],
          contentUrl: 'https://flutter.io',
          childDirected: false,
        ),
      );
    }
  }

  BannerAd myBanner;

  @override
  Widget build(BuildContext context) {
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return StreamBuilder<AuthenticationState>(
      stream: authenticationBloc.onAdd,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data is AuthenticationInProgress) {
          return Scaffold(
            appBar: AppBar(
              leading: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              title: Text(
                'AppBar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.orange,
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.face,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData && snapshot.data is AuthenticationFailure) {
          return Scaffold(
            appBar: AppBar(
              leading: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              title: Text(
                'AppBar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.orange,
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.face,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('no user login'),
                  RaisedButton(
                    child: const Text('Button'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () => authenticationBloc.read.add(null),
                  ),
                ],
              ),
            ),
          );
        } else {
          myBanner
            ..load()
            ..show(
              anchorOffset: 60.0,
              anchorType: AnchorType.bottom,
            );
          return Scaffold(
            appBar: AppBar(
              leading: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              title: Text(
                'AppBar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.orange,
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.face,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('no user login'),
                  RaisedButton(
                    child: const Text('Button'),
                    color: Colors.orange,
                    textColor: Colors.white,
                    onPressed: () => authenticationBloc.read.add(null),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
