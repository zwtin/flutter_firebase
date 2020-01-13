import 'package:flutter_firebase/models/current_user.dart';

abstract class AuthenticationRepository {
    Future<void> signOut();

    Future<bool> isSignedIn();

    Future<CurrentUser> getCurrentUser();
}
