import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar et informations de base
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[300],
            backgroundImage:
                user != null && user.photoURL != null
                    ? NetworkImage(user.photoURL!)
                    : null,
            child:
                user?.photoURL == null
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
          ),
          const SizedBox(height: 16),
          Text(
            user?.displayName ?? 'Utilisateur',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            user?.email ?? '',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),

          // Section des informations personnelles
          const Divider(),
          _buildSectionTitle('Informations personnelles'),
          _buildInfoCard(
            icon: Icons.person,
            title: 'Nom complet',
            subtitle: user?.displayName ?? 'Non défini',
            onTap: () {
              // Modifier le nom
            },
          ),
          _buildInfoCard(
            icon: Icons.email,
            title: 'Email',
            subtitle: user?.email ?? 'Non défini',
            onTap: () {
              // Modifier l'email
            },
          ),
          _buildInfoCard(
            icon: Icons.phone,
            title: 'Téléphone',
            subtitle: user?.phoneNumber ?? 'Non défini',
            onTap: () {
              // Modifier le téléphone
            },
          ),

          // Section académique
          const Divider(),
          _buildSectionTitle('Informations académiques'),
          _buildInfoCard(
            icon: Icons.school,
            title: 'Formation',
            subtitle: 'Licence Informatique',
            onTap: () {},
          ),
          _buildInfoCard(
            icon: Icons.business,
            title: 'Établissement',
            subtitle: 'IBA Institut',
            onTap: () {},
          ),
          _buildInfoCard(
            icon: Icons.grade,
            title: 'Niveau',
            subtitle: 'L3',
            onTap: () {},
          ),

          // Options du compte
          const Divider(),
          _buildSectionTitle('Options du compte'),
          _buildInfoCard(
            icon: Icons.security,
            title: 'Sécurité',
            subtitle: 'Mot de passe et authentification',
            onTap: () {},
          ),
          _buildInfoCard(
            icon: Icons.edit,
            title: 'Modifier le profil',
            subtitle: 'Changer la photo et les informations',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
