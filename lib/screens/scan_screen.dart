import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/utils/history_provider.dart';
import 'package:qrcode/utils/utils.dart';
import 'package:flutter/services.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
  );

  String? _lastScannedCode;
  DateTime? _lastScannedTime;

  @override
  Widget build(BuildContext context) {
    final feature = features.firstWhere((f) => f.id == 'scan');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(colors: feature.gradient).createShader(bounds),
                      child: const Text(
                        'Scan QR Code',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: MobileScanner(
                      controller: controller,
                      onDetect: (capture) {
                        final barcode = capture.barcodes.firstOrNull;
                        if (barcode?.rawValue == null) return;

                        final String code = barcode!.rawValue!;

                        final now = DateTime.now();
                        if (_lastScannedCode == code &&
                            _lastScannedTime != null &&
                            now.difference(_lastScannedTime!).inSeconds < 3) return;

                        _lastScannedCode = code;
                        _lastScannedTime = now;

                        Provider.of<HistoryProvider>(context, listen: false).addHistory(code);

                        HapticFeedback.mediumImpact();
                        controller.stop();

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ResultScreen(result: code)),
                        ).then((_) => controller.start());
                      },
                    ),
                  ).animate()
                      .fadeIn(duration: 600.ms)
                      .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      heroTag: "flip",
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: const Icon(Icons.flip_camera_ios, color: Colors.white, size: 28),
                      onPressed: () => controller.switchCamera(),
                    ),

                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: feature.gradient),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10)),
                        ],
                      ),
                      child: const Icon(Icons.qr_code_scanner, size: 40, color: Colors.white),
                    ).animate().scale(delay: 300.ms, duration: 800.ms, curve: Curves.easeOutBack),

                    const SizedBox(width: 56),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ResultScreen extends StatelessWidget {
  final String result;
  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/bg.png"), fit: BoxFit.cover),
        ),
        child: SafeArea(
          left: false,
          right: false,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: features.firstWhere((f) => f.id == 'scan').gradient),
                    shape: BoxShape.rectangle,
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10)),
                    ],
                  ),
                  child: const Icon(Icons.qr_code_2, size: 200, color: Colors.white70)),
                const SizedBox(height: 32),
                SelectableText(result, style: const TextStyle(fontSize: 18, color: Colors.white), textAlign: TextAlign.center),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text("Copy"),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: result));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied!")));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}