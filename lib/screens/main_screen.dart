import 'package:flutter/material.dart';
import 'package:payment_process/screens/dashboard_screen.dart';
import 'package:payment_process/screens/history_screen.dart';
import 'package:payment_process/screens/profile_screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: navBarBawah(context),
    );
  }

  Widget navBarBawah(BuildContext context) {
    final bottomNavTheme = Theme.of(context).bottomNavigationBarTheme;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      backgroundColor: bottomNavTheme.backgroundColor,
      elevation: 0,
      selectedItemColor: bottomNavTheme.selectedItemColor,
      unselectedItemColor: bottomNavTheme.unselectedItemColor,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 11,
      ),
      items: [
        tombolNav(
          context: context,
          index: 0,
          icon: Icons.dashboard_outlined,
          activeIcon: Icons.dashboard_rounded,
          label: 'Dashboard',
        ),
        tombolNav(
          context: context,
          index: 1,
          icon: Icons.history_outlined,
          activeIcon: Icons.history_rounded,
          label: 'History',
        ),
        tombolNav(
          context: context,
          index: 2,
          icon: Icons.person_outlined,
          activeIcon: Icons.person_rounded,
          label: 'Profile',
        ),
      ],
    );
  }

  BottomNavigationBarItem tombolNav({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bottomNavTheme = Theme.of(context).bottomNavigationBarTheme;
    final bool isSelected = _currentIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isSelected ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: isSelected
              ? BoxDecoration(
                  color: Color.fromARGB(120, 0, 94, 225),
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          child: Icon(
            isSelected ? activeIcon : icon,
            color: isSelected
                ? bottomNavTheme.selectedItemColor
                : bottomNavTheme.unselectedItemColor,
            size: 22,
          ),
        ),
      ),
      label: label,
    );
  }
}
