import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qrcode/screens/barcode_screens/barcode_root_screen.dart';
import 'package:qrcode/screens/history_screen.dart';
import 'package:qrcode/screens/qr_code_screens/qr_root_screen.dart';
import 'package:qrcode/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const QrRootScreen(),
    const BarcodeRootScreen(),
    const HistoryScreen(),
    SettingsScreen(),
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.qrCode),
              activeIcon: Icon(LucideIcons.qrCode, fontWeight: FontWeight.bold),
              label: 'QR',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.barChartHorizontal),
              activeIcon: Icon(
                LucideIcons.barChartHorizontal,
                fontWeight: FontWeight.bold,
              ),
              label: 'Barcode',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.history),
              activeIcon: Icon(
                LucideIcons.history,
                fontWeight: FontWeight.bold,
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.settings),
              activeIcon: Icon(
                LucideIcons.settings,
                fontWeight: FontWeight.bold,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
