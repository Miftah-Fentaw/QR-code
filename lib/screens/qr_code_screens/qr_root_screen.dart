import 'package:flutter/material.dart';
import 'package:qrcode/screens/qr_code_screens/generate_screen.dart';
import 'package:qrcode/screens/qr_code_screens/scan_screen.dart';

class QrRootScreen extends StatelessWidget {
  const QrRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('QR Code'),
          bottom: const TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Scan'),
              Tab(text: 'Generate'),
            ],
          ),
        ),
        body: const TabBarView(children: [ScanScreen(), GenerateScreen()]),
      ),
    );
  }
}
