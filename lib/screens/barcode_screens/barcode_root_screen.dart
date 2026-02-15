import 'package:flutter/material.dart';
import 'package:qrcode/screens/barcode_screens/bar_code_generator.dart';
import 'package:qrcode/screens/barcode_screens/bar_cod_scanner.dart';

import 'package:easy_localization/easy_localization.dart';

class BarcodeRootScreen extends StatelessWidget {
  const BarcodeRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('barcode'.tr()),
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
        body: const TabBarView(children: [BarCodScanner(), BarCodeGenerator()]),
      ),
    );
  }
}
