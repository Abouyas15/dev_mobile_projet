import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste de notifications exemple
    final notifications = [
      {
        'title': 'Cours annulé',
        'message': 'Le cours de mathématiques de demain est annulé',
        'time': 'Il y a 2 heures',
        'isRead': false,
      },
      {
        'title': 'Devoir à rendre',
        'message': 'N\'oubliez pas de rendre votre devoir de physique',
        'time': 'Il y a 1 jour',
        'isRead': true,
      },
      {
        'title': 'Nouvelle note',
        'message': 'Votre note de chimie est disponible',
        'time': 'Il y a 2 jours',
        'isRead': true,
      },
      {
        'title': 'Changement de salle',
        'message': 'Le cours d\'anglais aura lieu en salle B-204',
        'time': 'Il y a 3 jours',
        'isRead': true,
      },
    ];

    return notifications.isEmpty
        ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.bell_slash,
                size: 80,
                color: CupertinoColors.systemGrey,
              ),
              SizedBox(height: 20),
              Text(
                'Aucune notification',
                style: TextStyle(
                  fontSize: 20,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ],
          ),
        )
        : ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final bool isRead = notification['isRead'] as bool;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isRead
                        ? CupertinoColors.white
                        : CupertinoColors.systemBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey4,
                    blurRadius: isRead ? 2 : 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CupertinoListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isRead
                            ? CupertinoColors.systemGrey
                            : CupertinoColors.activeBlue,
                  ),
                  child: const Icon(
                    CupertinoIcons.bell_fill,
                    color: CupertinoColors.white,
                    size: 20,
                  ),
                ),
                title: Text(
                  notification['title'] as String,
                  style: TextStyle(
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification['message'] as String),
                    const SizedBox(height: 4),
                    Text(
                      notification['time'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
                trailing:
                    isRead
                        ? null
                        : Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                onTap: () {
                  // Action à effectuer lors du clic sur une notification
                },
              ),
            );
          },
        );
  }
}
