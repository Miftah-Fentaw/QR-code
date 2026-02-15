import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/utils/history_provider.dart';
import 'package:qrcode/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrcode/screens/barcode_screens/barcode_detail_screen.dart';
import 'package:qrcode/models/code_data_model.dart';

class BarCodScanner extends StatefulWidget {
  const BarCodScanner({super.key});

  @override
  State<BarCodScanner> createState() => _BarCodScannerScreenState();
}

class _BarCodScannerScreenState extends State<BarCodScanner> {
  final MobileScannerController controller = MobileScannerController(
    formats: [
      BarcodeFormat.aztec,
      BarcodeFormat.codabar,
      BarcodeFormat.code128,
      BarcodeFormat.code39,
      BarcodeFormat.code93,
      BarcodeFormat.dataMatrix,
      BarcodeFormat.ean13,
      BarcodeFormat.ean8,
      BarcodeFormat.itf,
      BarcodeFormat.pdf417,
      BarcodeFormat.upcA,
      BarcodeFormat.upcE,
    ],
  );

  String? _lastScannedCode;
  DateTime? _lastScannedTime;

  @override
  Widget build(BuildContext context) {
    final feature = features.firstWhere((f) => f.id == 'scan');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 12),
                  Text(
                    'scan_barcode'.tr(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Scanner view
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child:
                    ClipRRect(
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
                                  now.difference(_lastScannedTime!).inSeconds <
                                      3)
                                return;

                              _lastScannedCode = code;
                              _lastScannedTime = now;

                              Provider.of<HistoryProvider>(
                                context,
                                listen: false,
                              ).addHistory(code, CodeType.barcode);

                              HapticFeedback.mediumImpact();
                              controller.stop();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BarcodeDetailScreen(
                                    codeData: CodeData.fromContent(
                                      content: code,
                                      codeType: CodeType.barcode,
                                    ),
                                  ),
                                ),
                              ).then((_) => controller.start());
                            },
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1.0, 1.0),
                        ),
              ),
            ),

            // Controls
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: "flip",
                        backgroundColor: Colors.black,
                        child: const Icon(
                          Icons.flip_camera_ios,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => controller.switchCamera(),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner,
                          size: 40,
                          color: Colors.white,
                        ),
                      ).animate().scale(
                        delay: 300.ms,
                        duration: 800.ms,
                        curve: Curves.easeOutBack,
                      ),
                      FloatingActionButton(
                        heroTag: "gallery",
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.photo_library,
                          color: Colors.black,
                          size: 28,
                        ),
                        onPressed: () => _pickImageFromGallery(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      // Analyze the image for barcodes
      final BarcodeCapture? capture = await controller.analyzeImage(image.path);

      if (capture == null || capture.barcodes.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('no_barcode_found'.tr()),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      final barcode = capture.barcodes.first;

      if (barcode.format == BarcodeFormat.qrCode) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('not_a_qr_code'.tr()),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      if (barcode.rawValue == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('unable_to_read_barcode'.tr()),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }

      final String code = barcode.rawValue!;

      // Add to history
      if (context.mounted) {
        Provider.of<HistoryProvider>(
          context,
          listen: false,
        ).addHistory(code, CodeType.barcode);

        // Navigate to detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BarcodeDetailScreen(
              codeData: CodeData.fromContent(
                content: code,
                codeType: CodeType.barcode,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'error_scanning'.tr()}: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
