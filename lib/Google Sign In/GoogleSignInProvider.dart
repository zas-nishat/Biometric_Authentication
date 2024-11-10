import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;

  // Future<void> signInWithGoogle() async  {
  //   try {
  //     await googleSignIn.signIn();
  //   } catch (error) {
  //     print("Error signing in with Google: $error");
  //   }
  // }

  Future<void> signOut() async {
    await googleSignIn.signOut();
  }

  ///Firebase add user

  static Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignIn google = GoogleSignIn();
    final _auth = FirebaseAuth.instance;
    try {
      final googleUser = await google.signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );
      return await _auth.signInWithCredential(cred);
    } catch (e) {
      print(e.toString());
      return null; // Return null if login fails
    }
  }


}



