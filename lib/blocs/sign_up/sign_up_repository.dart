abstract class SignUpRepository {
  Future<void> signUpWithEmailAndPassword(String email, String password);

  Future<void> signUpWithGoogle();

  Future<void> signUpWithApple();
}
