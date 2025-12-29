import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/home_scree.dart';
import 'package:qrcode/utils/history_provider.dart';

void main() {
  runApp(
    
    ChangeNotifierProvider(
  create: (_) => HistoryProvider(),
  child: MyApp(),
)
  );
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyHomePage());
  }
}
