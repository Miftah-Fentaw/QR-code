import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qrcode/screens/bar_cod_scanner.dart';
import 'package:qrcode/screens/bar_code_generator.dart';
import 'package:qrcode/screens/generate_screen.dart';
import 'package:qrcode/screens/history_screen.dart';
import 'package:qrcode/screens/scan_screen.dart';
import 'package:qrcode/screens/settings_screen.dart';
import 'package:qrcode/utils/utils.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final double itemWidth =
        (MediaQuery.of(context).size.width - 20 * 2 - 14) / 2;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Column(
              children: [
                /// HEADER
                Column(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.indigo, Colors.purple],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: const Icon(
                        LucideIcons.qrCode,
                        color: Colors.white,
                        size: 40,
                      ),
                    ).animate().fadeIn().slideY(begin: 0.2),
                    const SizedBox(height: 10),
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          const LinearGradient(
                            colors: [Colors.indigo, Colors.purple],
                          ).createShader(bounds),
                      child: const Text(
                        'QR Code Utility',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Fast, simple QR code scanner & generator',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),

                /// EXPANDING CONTENT CARDS
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: List.generate(features.length, (index) {
                    final f = features[index];

                    return SizedBox(
                      width: itemWidth,
                      child: GestureDetector(
                        onTap: () => onNavigate(f.id),
                        child: Container(
                          padding: const EdgeInsets.all(20), // ⬅ bigger container
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: f.bg),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /// 🔥 BIG TOP ICON
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: f.gradient,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Icon(
                                    f.icon,
                                    color: Colors.white,
                                    size: 34, // ⬅ larger icon
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                f.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),

                              Text(
                                f.description,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slideY(begin: 0.2),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
          ),
        ),
      ),
    );
  }

  void onNavigate(String id) {
    Widget screen;
    switch (id) {
      case 'scan':
        screen = const ScanScreen();
        break;
      case 'generate':
        screen = const GenerateScreen();
        break;
      case 'history':
        screen = const HistoryScreen();
        break;
      case 'settings':
        screen =  SettingsScreen();
        break;
      case 'scan_bc':
        screen = const BarCodScanner();
        break;
      case 'generate_bc':
        screen = const BarCodeGenerator();
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
