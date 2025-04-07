import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

  // Connexion avec Google
  signInWithGoogle() async {
    try {
      // Si l'utilisateur est déjà connecté, on le déconnecte d'abord.
      await googleSignIn
          .signOut(); // Déconnexion de Google avant de se reconnecter
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await auth.signInWithCredential(authCredential);
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  // Déconnexion de Google et de Firebase
  googleSignOut() async {
    await googleSignIn.signOut(); // Déconnexion de Google
    await auth.signOut(); // Déconnexion de Firebase
  }
}
