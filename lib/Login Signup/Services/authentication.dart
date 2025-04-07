import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Inscription de l'utilisateur
  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Une erreur est survenue";
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        // Définir la langue en français
        await _auth.setLanguageCode('fr');

        // Validation de l'email
        bool emailValid = RegExp(
          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        ).hasMatch(email);
        if (!emailValid) {
          return "Format d'email invalide";
        }

        // Enregistrer l'utilisateur dans Firebase Authentication
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (cred.user != null) {
          // Ajouter l'utilisateur dans Firestore
          await _firestore.collection("users").doc(cred.user!.uid).set({
            'name': name,
            'uid': cred.user!.uid,
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
          });
          res = "success";
        }
      } else {
        res = "Veuillez remplir tous les champs";
      }
    } on FirebaseAuthException catch (e) {
      res = _handleAuthException(e);
    } catch (err) {
      res = "Erreur: ${err.toString()}";
    }
    return res;
  }

  // Connexion de l'utilisateur
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Une erreur est survenue";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Définir la langue en français
        await _auth.setLanguageCode('fr');

        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Veuillez remplir tous les champs";
      }
    } on FirebaseAuthException catch (e) {
      res = _handleAuthException(e);
    } catch (err) {
      res = "Erreur: ${err.toString()}";
    }
    return res;
  }

  // Déconnexion de l'utilisateur
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Erreur lors de la déconnexion: $e");
    }
  }

  // Obtenir l'utilisateur actuel
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Récupérer les données de l'utilisateur
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot doc =
            await _firestore.collection("users").doc(currentUser.uid).get();
        if (doc.exists) {
          return doc.data() as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      print("Erreur lors de la récupération des données: $e");
      return null;
    }
  }

  // Gestion des erreurs Firebase Auth
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return "Cet email est déjà utilisé par un autre compte";
      case 'invalid-email':
        return "Format d'email invalide";
      case 'weak-password':
        return "Le mot de passe est trop faible";
      case 'operation-not-allowed':
        return "La création de compte est désactivée";
      case 'user-not-found':
        return "Aucun utilisateur trouvé avec cet email";
      case 'wrong-password':
        return "Mot de passe incorrect";
      case 'invalid-credential':
        return "Identifiants invalides";
      case 'user-disabled':
        return "Ce compte a été désactivé";
      case 'too-many-requests':
        return "Trop de tentatives. Veuillez réessayer plus tard";
      default:
        return "Erreur: ${e.message ?? e.code}";
    }
  }
}
