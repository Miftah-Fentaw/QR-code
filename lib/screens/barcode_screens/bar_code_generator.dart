import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:barcode/barcode.dart';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/utils/history_provider.dart';
import 'package:qrcode/screens/barcode_screens/barcode_detail_screen.dart';
import 'package:qrcode/models/code_data_model.dart';

class BarCodeGenerator extends StatefulWidget {
  const BarCodeGenerator({super.key});

  @override
  State<BarCodeGenerator> createState() => _BarCodeGeneratorState();
}

class _BarCodeGeneratorState extends State<BarCodeGenerator> {
  final TextEditingController _controller = TextEditingController();
  String? barcodeData;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide > 600;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isTablet ? 800 : 600),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            /// BACK BUTTON

                            /// HEADER
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: isTablet ? 40 : 20,
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                        width: isTablet ? 150 : 100,
                                        height: isTablet ? 150 : 100,
                                        decoration: BoxDecoration(
                                          color: Colors.black, // B&W
                                          borderRadius: BorderRadius.circular(
                                            isTablet ? 30 : 20,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.2,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          CupertinoIcons.barcode,
                                          color: Colors.white,
                                          size: isTablet ? 54 : 36,
                                        ),
                                      )
                                      .animate()
                                      .fadeIn(duration: 600.ms)
                                      .slideY(begin: 0.2),

                                  const SizedBox(height: 10),

                                  Text(
                                    'barcode_generator'.tr(),
                                    style: TextStyle(
                                      fontSize: isTablet ? 32 : 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    'barcode_preview_subtitle'.tr(),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: isTablet ? 18 : 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// INPUT
                            Padding(
                              padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.05,
                              ),
                              child:
                                  TextField(
                                        controller: _controller,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: isTablet ? 18 : 14,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'barcode_hint'.tr(),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(
                                            0.85,
                                          ),
                                        ),
                                      )
                                      .animate()
                                      .fadeIn(duration: 600.ms)
                                      .slideY(begin: 0.3),
                            ),

                            const SizedBox(height: 20),

                            /// PREVIEW
                            AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  height: isTablet ? 300 : 200,
                                  width: isTablet ? 390 : 260,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child:
                                      barcodeData == null ||
                                          barcodeData!.isEmpty
                                      ? Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons.barcode,
                                                size: isTablet ? 72 : 48,
                                                color: Colors.black38,
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Barcode Preview',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: isTablet ? 18 : 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : BarcodeWidget(
                                          barcode:
                                              Barcode.code128(), // or EAN13, etc.
                                          data: barcodeData!,
                                          width: isTablet ? 300 : 200,
                                          height: isTablet ? 150 : 100,
                                        ),
                                )
                                .animate()
                                .fadeIn(duration: 600.ms)
                                .slideY(begin: 0.4),

                            const SizedBox(height: 20),

                            /// GENERATE BUTTON
                            ElevatedButton(
                                  onPressed: () {
                                    final text = _controller.text.trim();
                                    if (text.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'please_enter_text'.tr(),
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    // Save barcode data to history
                                    Provider.of<HistoryProvider>(
                                      context,
                                      listen: false,
                                    ).addHistory(text, CodeType.barcode);

                                    // Navigate to detail screen
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
                                  },

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black, // B&W
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 60 : 40,
                                      vertical: isTablet ? 20 : 15,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'generate_barcode'.tr(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isTablet ? 20 : 16,
                                    ),
                                  ),
                                )
                                .animate()
                                .fadeIn(duration: 600.ms)
                                .slideY(begin: 0.5),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
