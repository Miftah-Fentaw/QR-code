import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/utils/history_provider.dart';
import 'package:qrcode/screens/qr_code_screens/qr_detail_screen.dart';
import 'package:qrcode/screens/barcode_screens/barcode_detail_screen.dart';
import 'package:qrcode/models/code_data_model.dart';
import 'package:flutter/services.dart';

class UnifiedScanScreen extends StatefulWidget {
  const UnifiedScanScreen({super.key});

  @override
  State<UnifiedScanScreen> createState() => _UnifiedScanScreenState();
}

class _UnifiedScanScreenState extends State<UnifiedScanScreen> {
  bool _isFlashOn = false;
  bool _isProcessingImage = false;

  // Scan all formats simultaneously
  static const List<BarcodeFormat> _allFormats = [
    BarcodeFormat.qrCode,
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
  ];

  CodeType _codeTypeFromFormat(BarcodeFormat format) {
    return format == BarcodeFormat.qrCode ? CodeType.qr : CodeType.barcode;
  }

  void _navigateToDetail(BuildContext context, String code, CodeType type) {
    if (type == CodeType.qr) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QRDetailScreen(
            codeData: CodeData.fromContent(
              content: code,
              codeType: CodeType.qr,
            ),
          ),
        ),
      );
    } else {
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
  }

  void _onDetect(BarcodeCapture capture) {
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    final String code = barcode!.rawValue!;
    final codeType = _codeTypeFromFormat(barcode.format);

    HapticFeedback.mediumImpact();
    Provider.of<HistoryProvider>(
      context,
      listen: false,
    ).addHistory(code, codeType);
    _navigateToDetail(context, code, codeType);
  }

  Future<void> _scanFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() => _isProcessingImage = true);

    try {
      final result = await MobileScannerController().analyzeImage(
        pickedFile.path,
      );

      if (!mounted) return;
      setState(() => _isProcessingImage = false);

      if (result == null || result.barcodes.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('no_code_found'.tr())));
        return;
      }

      final barcode = result.barcodes.first;
      final code = barcode.rawValue ?? '';
      if (code.isEmpty) return;

      final codeType = _codeTypeFromFormat(barcode.format);
      HapticFeedback.mediumImpact();
      Provider.of<HistoryProvider>(
        context,
        listen: false,
      ).addHistory(code, codeType);
      _navigateToDetail(context, code, codeType);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isProcessingImage = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('error_scanning_image'.tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Scanner View
          MobileScanner(
            key: ValueKey('scanner_$_isFlashOn'),
            controller: MobileScannerController(
              formats: _allFormats,
              torchEnabled: _isFlashOn,
            ),
            onDetect: _onDetect,
          ),

          // Custom Overlay
          _buildScannerOverlay(),

          // Top Controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTopAction(
                    icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
                    label: 'light'.tr(),
                    onTap: () => setState(() => _isFlashOn = !_isFlashOn),
                  ),
                  // Center hint text
                  Text(
                    'scan_qr_or_barcode'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  _buildTopAction(
                    icon: Icons.photo_library_outlined,
                    label: 'gallery'.tr(),
                    onTap: _scanFromGallery,
                  ),
                ],
              ),
            ),
          ),

          // Loading overlay while analyzing gallery image
          if (_isProcessingImage)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF007BFF)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: SizedBox(
            height: 250,
            width: 250,
            child: Stack(
              children: [
                _buildCorner(top: 0, left: 0, quarterTurn: 0),
                _buildCorner(top: 0, right: 0, quarterTurn: 1),
                _buildCorner(bottom: 0, left: 0, quarterTurn: 3),
                _buildCorner(bottom: 0, right: 0, quarterTurn: 2),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCorner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required int quarterTurn,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: RotatedBox(
        quarterTurns: quarterTurn,
        child: CustomPaint(size: const Size(40, 40), painter: CornerPainter()),
      ),
    );
  }
}

class CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF007BFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 10)
      ..quadraticBezierTo(0, 0, 10, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
