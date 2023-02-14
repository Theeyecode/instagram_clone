import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:instagram_clone_course/firebase_options.dart';
import 'package:instagram_clone_course/state/auth/constant/constants.dart';
import 'package:instagram_clone_course/state/auth/models/auth_results.dart';
import 'package:instagram_clone_course/state/posts/typdefs/user_id.dart';

class Authenticator {
  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? "";
  // We don't want the email to be set to a value, we want to get it if its available
  String? get email => FirebaseAuth.instance.currentUser?.email;

  //Logout

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  //Facebook Login

  Future<AuthResult> loginWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();
    final token = loginResult.accessToken?.token;
    if (token == null) {
      return AuthResult.aborted;
    }
    //credentials to Use for Firesbase
    final oauthCredentials = FacebookAuthProvider.credential(token);
    try {
      await FirebaseAuth.instance.signInWithCredential(oauthCredentials);
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      final email = e.email;
      final credential = e.credential;
      if (e.code == Constants.accountExistsWithDifferentCredentialsError &&
          email != null &&
          credential != null) {
        final providers =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

        if (providers.contains(Constants.googleCom)) {
          await loginWithGoogle();
          FirebaseAuth.instance.currentUser
              ?.linkWithCredential(credential); // loginwithGoogle
        }
        return AuthResult.success;
      }
    }
    return AuthResult.failure;
  }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: DefaultFirebaseOptions.currentPlatform.iosClientId,
        scopes: [Constants.emailScope]);
    final signInAccount = await googleSignIn.signIn();
    if (signInAccount == null) {
      return AuthResult.aborted;
    }
    final googleAuth = await signInAccount.authentication;
    final authCredentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    try {
      await FirebaseAuth.instance.signInWithCredential(authCredentials);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.failure;
    }
  }

  //Google Login
}
