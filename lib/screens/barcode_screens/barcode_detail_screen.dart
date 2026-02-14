import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode/barcode.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrcode/models/code_data_model.dart';
import 'package:qrcode/utils/content_analyzer.dart';
import 'package:qrcode/utils/utils.dart';

class BarcodeDetailScreen extends StatefulWidget {
  final CodeData codeData;

  const BarcodeDetailScreen({super.key, required this.codeData});

  @override
  State<BarcodeDetailScreen> createState() => _BarcodeDetailScreenState();
}

class _BarcodeDetailScreenState extends State<BarcodeDetailScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final feature = features.firstWhere((f) => f.id == 'scan');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header
                Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 12),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: feature.gradient,
                          ).createShader(bounds),
                          child: const Text(
                            'Barcode Details',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.2, end: 0),

                const SizedBox(height: 32),

                // Barcode Display
                Screenshot(
                      controller: _screenshotController,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: BarcodeWidget(
                          barcode: Barcode.code128(),
                          data: widget.codeData.content,
                          width: 280,
                          height: 140,
                          drawText: true,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.8, 0.8)),

                const SizedBox(height: 24),

                // Content Display
                Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getContentIcon(),
                                color: feature.gradient.first,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _getContentTypeLabel(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: feature.gradient.first,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SelectableText(
                            widget.codeData.content,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 32),

                // Action Buttons
                _buildActionButtons(context, feature),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, feature) {
    return Column(
      children: [
        // Primary Actions Row
        Row(
          children: [
            Expanded(
              child:
                  _ActionButton(
                        icon: Icons.copy,
                        label: 'Copy',
                        gradient: feature.gradient,
                        onPressed: () => _copyToClipboard(context),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 300.ms)
                      .slideX(begin: -0.3, end: 0),
            ),
            const SizedBox(width: 12),
            Expanded(
              child:
                  _ActionButton(
                        icon: Icons.share,
                        label: 'Share',
                        gradient: feature.gradient,
                        onPressed: () => _shareContent(context),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 350.ms)
                      .slideX(begin: -0.3, end: 0),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Conditional Actions based on content type
        if (widget.codeData.contentType == ContentType.url)
          _ActionButton(
                icon: Icons.open_in_browser,
                label: 'Open URL',
                gradient: feature.gradient,
                onPressed: () => _openUrl(context),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 400.ms)
              .slideY(begin: 0.3, end: 0),

        if (widget.codeData.contentType == ContentType.phone) ...[
          const SizedBox(height: 12),
          _ActionButton(
                icon: Icons.phone,
                label: 'Call Phone Number',
                gradient: feature.gradient,
                onPressed: () => _callPhone(context),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 400.ms)
              .slideY(begin: 0.3, end: 0),
        ],

        if (widget.codeData.contentType == ContentType.email) ...[
          const SizedBox(height: 12),
          _ActionButton(
                icon: Icons.email,
                label: 'Send Email',
                gradient: feature.gradient,
                onPressed: () => _sendEmail(context),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 400.ms)
              .slideY(begin: 0.3, end: 0),
        ],

        const SizedBox(height: 12),

        // Secondary Actions Row
        Row(
          children: [
            Expanded(
              child:
                  _ActionButton(
                        icon: Icons.search,
                        label: 'Search',
                        gradient: feature.gradient,
                        onPressed: () => _searchGoogle(context),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 450.ms)
                      .slideX(begin: 0.3, end: 0),
            ),
            const SizedBox(width: 12),
            Expanded(
              child:
                  _ActionButton(
                        icon: Icons.save,
                        label: 'Save Image',
                        gradient: feature.gradient,
                        onPressed: () => _saveImage(context),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 500.ms)
                      .slideX(begin: 0.3, end: 0),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getContentIcon() {
    switch (widget.codeData.contentType) {
      case ContentType.url:
        return Icons.link;
      case ContentType.phone:
        return Icons.phone;
      case ContentType.email:
        return Icons.email;
      case ContentType.plainText:
        return CupertinoIcons.barcode;
    }
  }

  String _getContentTypeLabel() {
    switch (widget.codeData.contentType) {
      case ContentType.url:
        return 'URL';
      case ContentType.phone:
        return 'Phone Number';
      case ContentType.email:
        return 'Email Address';
      case ContentType.plainText:
        return 'Barcode Data';
    }
  }

  // Action handlers
  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.codeData.content));
    _showSnackBar(context, 'Copied to clipboard!');
  }

  void _shareContent(BuildContext context) async {
    await Share.share(widget.codeData.content);
  }

  void _openUrl(BuildContext context) async {
    final success = await ContentAnalyzer.launchURL(widget.codeData.content);
    if (!success && context.mounted) {
      _showSnackBar(context, 'Failed to open URL', isError: true);
    }
  }

  void _callPhone(BuildContext context) async {
    final success = await ContentAnalyzer.launchPhone(widget.codeData.content);
    if (!success && context.mounted) {
      _showSnackBar(context, 'Failed to open phone dialer', isError: true);
    }
  }

  void _sendEmail(BuildContext context) async {
    final success = await ContentAnalyzer.launchEmail(widget.codeData.content);
    if (!success && context.mounted) {
      _showSnackBar(context, 'Failed to open email app', isError: true);
    }
  }

  void _searchGoogle(BuildContext context) async {
    final success = await ContentAnalyzer.searchOnGoogle(
      widget.codeData.content,
    );
    if (!success && context.mounted) {
      _showSnackBar(context, 'Failed to open browser', isError: true);
    }
  }

  void _saveImage(BuildContext context) async {
    try {
      // Request storage permission
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted && !status.isLimited) {
          if (context.mounted) {
            _showSnackBar(context, 'Storage permission denied', isError: true);
          }
          return;
        }
      }

      // Capture the screenshot
      final image = await _screenshotController.capture();
      if (image == null) {
        if (context.mounted) {
          _showSnackBar(context, 'Failed to capture image', isError: true);
        }
        return;
      }

      // Get the directory to save the image
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        if (context.mounted) {
          _showSnackBar(
            context,
            'Failed to get storage directory',
            isError: true,
          );
        }
        return;
      }

      // Save the image
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/barcode_$timestamp.png';
      final file = File(filePath);
      await file.writeAsBytes(image);

      if (context.mounted) {
        _showSnackBar(context, 'Image saved to Downloads!');
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Failed to save image: $e', isError: true);
      }
    }
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white.withOpacity(0.9),
        shadowColor: Colors.black26,
        elevation: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                LinearGradient(colors: gradient).createShader(bounds),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: gradient.first,
            ),
          ),
        ],
      ),
    );
  }
}
