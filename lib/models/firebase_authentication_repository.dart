import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/repositories/sign_up_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_firebase/repositories/sign_in_repository.dart';
import 'package:flutter_firebase/entities/current_user.dart';

class FirebaseAuthenticationRepository
    implements SignInRepository, SignUpRepository {
  FirebaseAuthenticationRepository(
      {FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  @override
  Future<CurrentUser> getCurrentUser() async {
    final currentUser = await _firebaseAuth.currentUser();
    return CurrentUser(
        id: currentUser.uid ?? '',
        name: currentUser.displayName ?? '',
        photoUrl: currentUser.photoUrl ?? '',
        isAnonymous: currentUser.isAnonymous,
        createdAt: currentUser.metadata.creationTime,
        updatedAt: currentUser.metadata.lastSignInTime);
  }

  @override
  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  @override
  Future<void> signOut() {
    return Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
  }

  @override
  Future<void> signInAnonymously() async {
    await _firebaseAuth.signInAnonymously();
  }

  @override
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.sendSignInWithEmailLink(
      email: email,
      url: 'https://zwtin.page.link/zXbp',
      handleCodeInApp: true,
      iOSBundleID: 'com.zwtin.flutterFirebase',
      androidPackageName: 'com.zwtin.flutter_firebase',
      androidInstallIfNotAvailable: true,
      androidMinimumVersion: '21',
    );
  }

  @override
  Future<void> signInWithEmailAndLink(
    String email,
    String password,
    String link,
  ) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firebaseAuth.signInWithEmailAndLink(
      email: email,
      link: link,
    );
  }

  @override
  Future<void> signUpWithGoogle() async {}

  @override
  Future<void> signUpWithApple() async {}
}
