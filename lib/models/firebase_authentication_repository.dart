import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/use_cases/current_user.dart';
import 'package:flutter_firebase/repositories/authentication_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthenticationRepository implements AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<CurrentUser> getCurrentUserStream() {
    return _firebaseAuth.onAuthStateChanged.map(
      (FirebaseUser firebaseUser) {
        if (firebaseUser == null) {
          return null;
        }
        return CurrentUser(
          id: firebaseUser.uid,
        );
      },
    );
  }

  @override
  Future<CurrentUser> getCurrentUser() async {
    final currentUser = await _firebaseAuth.currentUser();
    return CurrentUser(
      id: currentUser.uid ?? '',
    );
  }

  @override
  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  @override
  Future<void> signOut() {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  @override
  Future<void> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> sendSignInWithEmailLink({
    @required String email,
  }) async {
    await _firebaseAuth.sendSignInWithEmailLink(
      email: email,
      url: 'https://flutter-firebase-6f534.firebaseapp.com/',
      handleCodeInApp: true,
      iOSBundleID: 'com.zwtin.flutterFirebase',
      androidPackageName: 'com.zwtin.flutter_firebase',
      androidInstallIfNotAvailable: true,
      androidMinimumVersion: '1',
    );
  }

  @override
  Future<void> createUserWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signInWithGoogle() async {
    final _googleSignIn = GoogleSignIn();
    var currentUser = _googleSignIn.currentUser;
    currentUser ??= await _googleSignIn.signInSilently();
    currentUser ??= await _googleSignIn.signIn();
    final googleAuth = await currentUser.authentication;
    final credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<void> signInWithApple() async {
    final result = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
//    switch (result.state) {
//      case AuthorizationStatus.authorized:
    const oAuthProvider = OAuthProvider(providerId: 'apple.com');
    final credential = oAuthProvider.getCredential(
      idToken: result.identityToken,
      accessToken: result.authorizationCode,
    );
    await _firebaseAuth.signInWithCredential(credential);
//        break;
//
//      case AuthorizationStatus.error:
//        throw Exception();
//        break;
//
//      case AuthorizationStatus.cancelled:
//        throw Exception();
//        break;
//    }
  }
}
