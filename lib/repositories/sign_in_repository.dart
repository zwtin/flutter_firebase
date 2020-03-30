import 'package:flutter_firebase/entities/current_user.dart';

abstract class SignInRepository {
  Future<void> signOut();

  Future<bool> isSignedIn();

  Future<CurrentUser> getCurrentUser();

  Future<void> signInWithEmailAndPassword(String email, String password);

  Future<void> signInWithGoogle();

  Future<void> signInAnonymously();
}
