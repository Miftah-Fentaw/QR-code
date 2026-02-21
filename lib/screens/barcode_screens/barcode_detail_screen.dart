import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Text(
                          'barcode_details'.tr(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
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
                          border: Border.all(color: Colors.black12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: BarcodeWidget(
                          barcode: Barcode.code128(),
                          data: widget.codeData.content,
                          width: 280,
                          height: 140,
                          drawText: true,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
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
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getContentIcon(),
                                color: Colors.black,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _getContentTypeLabel(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
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
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width * 0.42;
    const networkingColor = Colors.indigo;

    return Column(
      children: [
        // Primary Actions Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: buttonWidth,
              child:
                  _ActionButton(
                        icon: Icons.copy,
                        label: 'copy'.tr(),
                        onPressed: () => _copyToClipboard(context),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 300.ms)
                      .slideX(begin: -0.3, end: 0),
            ),
            SizedBox(
              width: buttonWidth,
              child:
                  _ActionButton(
                        icon: Icons.share,
                        label: 'share'.tr(),
                        onPressed: () => _shareContent(context),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 350.ms)
                      .slideX(begin: 0.3, end: 0),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Conditional Actions based on content type
        if (widget.codeData.contentType == ContentType.url)
          _ActionButton(
                icon: Icons.language,
                label: 'open_in_browser'.tr(),
                iconColor: networkingColor,
                onPressed: () => _openUrl(context),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 400.ms)
              .slideY(begin: 0.3, end: 0),

        if (widget.codeData.contentType == ContentType.phone) ...[
          const SizedBox(height: 12),
          _ActionButton(
                icon: Icons.phone,
                label: 'call_number'.tr(),
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
                label: 'send_email'.tr(),
                iconColor: networkingColor,
                onPressed: () => _sendEmail(context),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 400.ms)
              .slideY(begin: 0.3, end: 0),
        ],

        const SizedBox(height: 12),

        // Secondary Actions Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: buttonWidth,
              child:
                  _ActionButton(
                        icon: Icons.language,
                        label: 'Open in browser',
                        iconColor: Colors.white,
                        onPressed: () => _searchGoogle(context),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 450.ms)
                      .slideX(begin: -0.3, end: 0),
            ),
            SizedBox(
              width: buttonWidth,
              child:
                  _ActionButton(
                        icon: Icons.save,
                        label: 'save'.tr(),
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
        return 'url'.tr();
      case ContentType.phone:
        return 'phone_number'.tr();
      case ContentType.email:
        return 'email_address'.tr();
      case ContentType.plainText:
        return 'barcode_data'.tr();
    }
  }

  // Action handlers
  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.codeData.content));
    _showSnackBar(context, 'copied'.tr());
  }

  void _shareContent(BuildContext context) async {
    await Share.share(widget.codeData.content);
  }

  void _openUrl(BuildContext context) async {
    final success = await ContentAnalyzer.launchURL(widget.codeData.content);
    if (!success && context.mounted) {
      _showSnackBar(context, 'failed_open_url'.tr(), isError: true);
    }
  }

  void _callPhone(BuildContext context) async {
    final success = await ContentAnalyzer.launchPhone(widget.codeData.content);
    if (!success && context.mounted) {
      _showSnackBar(context, 'failed_open_dialer'.tr(), isError: true);
    }
  }

  void _sendEmail(BuildContext context) async {
    final success = await ContentAnalyzer.launchEmail(widget.codeData.content);
    if (!success && context.mounted) {
      _showSnackBar(context, 'failed_open_email'.tr(), isError: true);
    }
  }

  void _searchGoogle(BuildContext context) async {
    final success = await ContentAnalyzer.searchOnGoogle(
      widget.codeData.content,
    );
    if (!success && context.mounted) {
      _showSnackBar(context, 'failed_open_browser'.tr(), isError: true);
    }
  }

  void _saveImage(BuildContext context) async {
    try {
      // Request storage permission
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted && !status.isLimited) {
          if (context.mounted) {
            _showSnackBar(context, 'permission_denied'.tr(), isError: true);
          }
          return;
        }
      }

      // Capture the screenshot
      final image = await _screenshotController.capture();
      if (image == null) {
        if (context.mounted) {
          _showSnackBar(context, 'failed_capture'.tr(), isError: true);
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
          _showSnackBar(context, 'failed_storage_dir'.tr(), isError: true);
        }
        return;
      }

      // Save the image
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/barcode_$timestamp.png';
      final file = File(filePath);
      await file.writeAsBytes(image);

      if (context.mounted) {
        _showSnackBar(context, 'image_saved'.tr());
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, '${'failed_save'.tr()}: $e', isError: true);
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
        backgroundColor: isError ? Colors.red : Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor ?? Colors.white, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
