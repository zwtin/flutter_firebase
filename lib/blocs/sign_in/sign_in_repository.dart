abstract class SignInRepository {
  Future<void> signInWithEmailAndPassword(String email, String password);

  Future<void> signInWithGoogle();

  Future<void> signInAnonymously();
}
