import 'package:flutter/material.dart';
import 'package:qrcode/screens/barcode_screens/bar_code_generator.dart';
import 'package:qrcode/screens/barcode_screens/bar_cod_scanner.dart';

class BarcodeRootScreen extends StatelessWidget {
  const BarcodeRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Barcode'),
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
        body: const TabBarView(children: [BarCodScanner(), BarCodeGenerator()]),
      ),
    );
  }
}
