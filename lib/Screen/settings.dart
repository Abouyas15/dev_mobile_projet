import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  bool _emailUpdates = true;
  String _selectedLanguage = 'Français';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section Apparence
          _buildSectionHeader('Apparence'),
          SwitchListTile(
            title: const Text('Mode sombre'),
            subtitle: const Text('Activer le thème sombre'),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
            },
          ),
          const Divider(),

          // Section Notifications
          _buildSectionHeader('Notifications'),
          SwitchListTile(
            title: const Text('Notifications push'),
            subtitle: const Text('Recevoir des notifications sur l\'appareil'),
            value: _notifications,
            onChanged: (value) {
              setState(() {
                _notifications = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Emails'),
            subtitle: const Text('Recevoir des mises à jour par email'),
            value: _emailUpdates,
            onChanged: (value) {
              setState(() {
                _emailUpdates = value;
              });
            },
          ),
          const Divider(),

          // Section Langue
          _buildSectionHeader('Langue'),
          ListTile(
            title: const Text('Langue de l\'application'),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showLanguageDialog,
          ),
          const Divider(),

          // Section Compte
          _buildSectionHeader('Compte'),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Confidentialité'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigation vers paramètres de confidentialité
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Sécurité'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigation vers paramètres de sécurité
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Données personnelles'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigation vers paramètres des données personnelles
            },
          ),
          const Divider(),

          // Section Support
          _buildSectionHeader('Support'),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Centre d\'aide'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigation vers le centre d'aide
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('À propos'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigation vers "à propos"
            },
          ),
          const Divider(),

          // Déconnexion
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text(
              'Se déconnecter',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              // Déconnexion
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Future<void> _showLanguageDialog() async {
    final languages = ['Français', 'English', 'Español', 'العربية'];

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choisir une langue'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                return ListTile(
                  title: Text(language),
                  trailing:
                      language == _selectedLanguage
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                  onTap: () {
                    setState(() {
                      _selectedLanguage = language;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }
}
