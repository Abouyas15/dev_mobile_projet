import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CupertinoColors.systemGrey4,
              image:
                  user != null && user.photoURL != null
                      ? DecorationImage(
                        image: NetworkImage(user.photoURL!),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child:
                user?.photoURL == null
                    ? const Icon(
                      CupertinoIcons.person_solid,
                      size: 50,
                      color: CupertinoColors.white,
                    )
                    : null,
          ),
          const SizedBox(height: 10),
          Text(
            user != null
                ? "Félicitations\nBienvenue ${user.displayName ?? 'Utilisateur'}"
                : "Utilisateur non connecté",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          CupertinoButton(
            color: CupertinoColors.activeBlue,
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            child: const Text("Se déconnecter"),
          ),
        ],
      ),
    );
  }
}
