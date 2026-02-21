import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qrcode/screens/history_screen.dart';
import 'package:qrcode/screens/settings_screen.dart';
import 'package:qrcode/screens/unified_scan_screen.dart';
import 'package:qrcode/screens/unified_generate_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const UnifiedScanScreen(),
    const UnifiedGenerateScreen(),
    const HistoryScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(LucideIcons.scanLine),
              activeIcon: const Icon(
                LucideIcons.scanLine,
                fontWeight: FontWeight.bold,
              ),
              label: 'scan'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(LucideIcons.loader2),
              activeIcon: const Icon(
                LucideIcons.loader,
                fontWeight: FontWeight.bold,
              ),
              label: 'generate'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(LucideIcons.history),
              activeIcon: const Icon(
                LucideIcons.history,
                fontWeight: FontWeight.bold,
              ),
              label: 'history'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(LucideIcons.settings),
              activeIcon: const Icon(
                LucideIcons.settings,
                fontWeight: FontWeight.bold,
              ),
              label: 'settings'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
