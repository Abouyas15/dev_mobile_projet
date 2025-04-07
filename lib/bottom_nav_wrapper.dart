import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ibamedt/Screen/Acceuil.dart';
import 'package:provider/provider.dart';
import 'package:ibamedt/Provider/navigation_provider.dart';
import 'package:ibamedt/Screen/edt.dart';
import 'package:ibamedt/Screen/notifications.dart';
import 'package:ibamedt/Screen/profile.dart';
import 'package:ibamedt/Screen/settings.dart';

class BottomNavWrapper extends StatefulWidget {
  final int initialIndex;

  const BottomNavWrapper({super.key, required this.initialIndex});

  @override
  State<BottomNavWrapper> createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  late int _currentIndex;

  final List<Widget> _pages = [
    const HomeScreen(),
    const EDTScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  final List<String> _titles = [
    'Accueil',
    'EDT',
    'Notifications',
    'Profil',
    'Paramètres',
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    // Mettre à jour le provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<NavigationProvider>(
          context,
          listen: false,
        ).setIndex(_currentIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            Provider.of<NavigationProvider>(
              context,
              listen: false,
            ).setIndex(index);
          });
        },
        activeColor: CupertinoColors.activeBlue,
        inactiveColor: CupertinoColors.systemGrey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            label: 'EDT',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bell),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(middle: Text(_titles[index])),
          child: SafeArea(child: _pages[index]),
        );
      },
    );
  }
}
