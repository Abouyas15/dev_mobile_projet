import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EDTScreen extends StatelessWidget {
  const EDTScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          CupertinoIcons.calendar,
          size: 80,
          color: CupertinoColors.systemIndigo,
        ),
        const SizedBox(height: 20),
        const Text(
          'Emploi du temps',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        // Exemple d'EDT avec une liste de cours
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemGrey4,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cours ${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemIndigo.withOpacity(
                                0.2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${8 + index}:00 - ${9 + index}:00',
                              style: const TextStyle(
                                color: CupertinoColors.systemIndigo,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('Professeur: Jean Dupont'),
                      Text('Salle: A-${index + 100}'),
                      const SizedBox(height: 10),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.info,
                                  color: CupertinoColors.activeBlue,
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Détails',
                                  style: TextStyle(
                                    color: CupertinoColors.activeBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
