import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode/barcode.dart' as bc;
import 'package:provider/provider.dart';
import 'package:qrcode/utils/history_provider.dart';
import 'package:qrcode/screens/qr_code_screens/qr_detail_screen.dart';
import 'package:qrcode/screens/barcode_screens/barcode_detail_screen.dart';
import 'package:qrcode/models/code_data_model.dart';
import 'package:flutter/cupertino.dart';

class UnifiedGenerateScreen extends StatefulWidget {
  const UnifiedGenerateScreen({super.key});

  @override
  State<UnifiedGenerateScreen> createState() => _UnifiedGenerateScreenState();
}

class _UnifiedGenerateScreenState extends State<UnifiedGenerateScreen> {
  final TextEditingController _controller = TextEditingController();
  CodeType _selectedType = CodeType.qr;
  String? _generatedData;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide > 600;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        title: Text(
          'generate'.tr(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isTablet ? 800 : 600),
                  child: Column(
                    children: [
                      // Mode Selector
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CupertinoSlidingSegmentedControl<CodeType>(
                          backgroundColor: Colors.transparent,
                          thumbColor: Colors.black,
                          groupValue: _selectedType,
                          children: {
                            CodeType.qr: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              child: Text(
                                'qr_code'.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _selectedType == CodeType.qr
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            CodeType.barcode: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              child: Text(
                                'barcode'.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _selectedType == CodeType.barcode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          },
                          onValueChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedType = value;
                                _generatedData = null;
                              });
                            }
                          },
                        ),
                      ).animate().fadeIn().slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 28),

                      // Title
                      Text(
                        _selectedType == CodeType.qr
                            ? 'qr_generator'.tr()
                            : 'barcode_generator'.tr(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ).animate().fadeIn(),

                      const SizedBox(height: 24),

                      // Input Field
                      TextField(
                        controller: _controller,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.black87),
                        onChanged: (value) {
                          setState(() {
                            _generatedData = value.trim().isEmpty
                                ? null
                                : value.trim();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: _selectedType == CodeType.qr
                              ? 'qr_generator_hint'.tr()
                              : 'barcode_hint'.tr(),
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF007BFF),
                              width: 1.5,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ).animate().fadeIn().slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 24),

                      // Preview Area
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _buildPreview(),
                      ).animate().fadeIn().slideY(begin: 0.3, end: 0),

                      const SizedBox(height: 28),

                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _onGenerate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'view_details'.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ).animate().fadeIn().slideY(begin: 0.4, end: 0),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (_generatedData == null || _generatedData!.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.image, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'preview_will_appear_here'.tr(),
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      );
    }

    if (_selectedType == CodeType.qr) {
      return AspectRatio(
        aspectRatio: 1,
        child: PrettyQrView.data(
          data: _generatedData!,
          decoration: const PrettyQrDecoration(shape: PrettyQrSmoothSymbol()),
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: 2,
        child: BarcodeWidget(
          barcode: bc.Barcode.code128(),
          data: _generatedData!,
          drawText: false,
        ),
      );
    }
  }

  void _onGenerate() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('please_enter_text'.tr())));
      return;
    }

    Provider.of<HistoryProvider>(
      context,
      listen: false,
    ).addHistory(text, _selectedType);

    if (_selectedType == CodeType.qr) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QRDetailScreen(
            codeData: CodeData.fromContent(
              content: text,
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
              content: text,
              codeType: CodeType.barcode,
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
