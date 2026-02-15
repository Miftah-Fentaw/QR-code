import 'package:flutter/material.dart';
import 'package:qrcode/screens/qr_code_screens/generate_screen.dart';
import 'package:qrcode/screens/qr_code_screens/scan_screen.dart';

import 'package:easy_localization/easy_localization.dart';

class QrRootScreen extends StatelessWidget {
  const QrRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('qr_code'.tr()),
          bottom: TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'scan'.tr()),
              Tab(text: 'generate'.tr()),
            ],
          ),
        ),
        body: const TabBarView(children: [ScanScreen(), GenerateScreen()]),
      ),
    );
  }
}
