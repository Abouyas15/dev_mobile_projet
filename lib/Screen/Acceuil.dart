import 'package:flutter/cupertino.dart';
import 'package:ibamedt/Screen/profile.dart';
import 'package:ibamedt/Screen/settings.dart';
import 'package:provider/provider.dart';
import '../Provider/navigation_provider.dart';
import 'edt.dart';
import 'notifications.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({super.key, required this.initialIndex});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  late int _currentIndex;

  final List<Widget> _pages = [
    const EDTScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  final List<String> _titles = ['EDT', 'Notifications', 'Profil', 'Paramètres'];

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
          // BottomNavigationBarItem(
          //   icon: Icon(CupertinoIcons.home),
          //   label: 'Accueil',
          // ),
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
