import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qrcode/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:qrcode/utils/history_provider.dart';


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
    final feature = features.firstWhere((f) => f.id == 'generate');

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
            physics: const NeverScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
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
                                  gradient: LinearGradient(
                                    colors: feature.gradient,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  feature.icon,
                                  color: Colors.white,
                                  size: 34,
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: 0.2, end: 0),
                          const SizedBox(height: 10),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: feature.gradient,
                            ).createShader(bounds),
                            child: Text(
                              feature.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            feature.description,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding:  EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                      child: TextField(
                            controller: _controller,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Enter text, URL, or contact info',
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        LucideIcons.qrCode,
                                        size: 50,
                                        color: Colors.black38,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'QR Code Preview',
                                        style: TextStyle(color: Colors.black54),
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
                            setState(() {
                              qrData = _controller.text.trim();
                            });
                            if (qrData!.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please enter text to generate a QR",
                                  ),
                                ),
                              );
                            }
                            if (qrData!.isNotEmpty) {
  Provider.of<HistoryProvider>(context, listen: false).addHistory(qrData!);
}
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
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
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
