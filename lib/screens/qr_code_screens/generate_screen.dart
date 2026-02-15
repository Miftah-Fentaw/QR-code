import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(isTablet ? 30 : 20),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.2,
                                              ),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          LucideIcons.qrCode,
                                          color: Colors.white,
                                          size: isTablet ? 50 : 34,
                                        ),
                                      )
                                      .animate()
                                      .fadeIn(duration: 600.ms)
                                      .slideY(begin: 0.2, end: 0),
                                  const SizedBox(height: 10),
                                  Text(
                                    'qr_generator'.tr(),
                                    style: TextStyle(
                                      fontSize: isTablet ? 32 : 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'qr_preview_subtitle'.tr(),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: isTablet ? 18 : 14,
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
                                        style: TextStyle(
                                          fontSize: isTablet ? 18 : 14,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'qr_generator_hint'.tr(),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(
                                            0.8,
                                          ),
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
                                  height: isTablet ? 300 : 200,
                                  width: isTablet ? 300 : 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.black26),
                                  ),
                                  child: qrData == null || qrData!.isEmpty
                                      ? Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                LucideIcons.qrCode,
                                                size: isTablet ? 80 : 50,
                                                color: Colors.black38,
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'QR Code Preview',
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: isTablet ? 18 : 14,
                                                ),
                                              ),
                                              Text(
                                                'Generated QR will appear here',
                                                style: TextStyle(
                                                  color: Colors.black38,
                                                  fontSize: isTablet ? 14 : 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Center(
                                          child: PrettyQrView.data(
                                            data: qrData!,

                                            decoration:
                                                const PrettyQrDecoration(
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
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 60 : 40,
                                      vertical: isTablet ? 20 : 15,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'generate_qr_code'.tr(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isTablet ? 20 : 16,
                                    ),
                                  ),
                                )
                                .animate()
                                .fadeIn(duration: 600.ms)
                                .slideY(begin: 0.5, end: 0),
                            const Spacer(),
                            const SizedBox(height: 20),
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
