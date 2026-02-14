import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        /// BACK BUTTON

                        /// HEADER
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          child: Column(
                            children: [
                              Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.black, // B&W
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.barcode,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 600.ms)
                                  .slideY(begin: 0.2),

                              const SizedBox(height: 10),

                              const Text(
                                'Barcode Generator',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),

                              const SizedBox(height: 5),

                              const Text(
                                'Generate barcodes from text or numbers',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
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
                                    decoration: InputDecoration(
                                      hintText: 'Enter barcode data',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.85),
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
                          height: 200,
                          width: 260,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.black26),
                          ),
                          child: barcodeData == null || barcodeData!.isEmpty
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.barcode,
                                        size: 48,
                                        color: Colors.black38,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Barcode Preview',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                )
                              : BarcodeWidget(
                                  barcode: Barcode.code128(), // or EAN13, etc.
                                  data: barcodeData!,
                                  width: 200,
                                  height: 100,
                                ),
                        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.4),

                        const SizedBox(height: 20),

                        /// GENERATE BUTTON
                        ElevatedButton(
                          onPressed: () {
                            final text = _controller.text.trim();
                            if (text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please enter data to generate barcode',
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Generate Barcode',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.5),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
