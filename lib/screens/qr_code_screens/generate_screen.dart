import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import 'package:provider/provider.dart';
import 'package:qrcode/utils/history_provider.dart';
import 'package:qrcode/screens/qr_code_screens/qr_detail_screen.dart';
import 'package:qrcode/models/code_data_model.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final TextEditingController _controller = TextEditingController();
  String? qrData;

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
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      LucideIcons.qrCode,
                                      color: Colors.white,
                                      size: 34,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 600.ms)
                                  .slideY(begin: 0.2, end: 0),
                              const SizedBox(height: 10),
                              const Text(
                                'QR Generator',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Generate QR codes from text',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.05,
                          ),
                          child:
                              TextField(
                                    controller: _controller,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText:
                                          'Enter text, URL, or contact info',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.8),
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 600.ms)
                                  .slideY(begin: 0.3, end: 0),
                        ),

                        const SizedBox(height: 20),

                        AnimatedContainer(
                              padding: const EdgeInsets.all(16),
                              duration: const Duration(milliseconds: 500),
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.black26),
                              ),
                              child: qrData == null || qrData!.isEmpty
                                  ? const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            LucideIcons.qrCode,
                                            size: 50,
                                            color: Colors.black38,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            'QR Code Preview',
                                            style: TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Text(
                                            'Generated QR will appear here',
                                            style: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Center(
                                      child: PrettyQrView.data(
                                        data: qrData!,

                                        decoration: const PrettyQrDecoration(
                                          shape: PrettyQrSmoothSymbol(),
                                        ),
                                      ),
                                    ),
                            )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.4, end: 0),

                        const SizedBox(height: 20),

                        ElevatedButton(
                              onPressed: () {
                                final text = _controller.text.trim();
                                if (text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please enter text to generate a QR",
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Add to history
                                Provider.of<HistoryProvider>(
                                  context,
                                  listen: false,
                                ).addHistory(text, CodeType.qr);

                                // Navigate to detail screen
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
                                'Generate QR Code',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .slideY(begin: 0.5, end: 0),
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
