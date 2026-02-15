import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            LucideIcons.settings,
                            color: Colors.white,
                            size: 34,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 16),
                    Text(
                      'settings'.tr(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildSettingsCard(
                      icon: LucideIcons.languages,
                      title: 'language'.tr(),
                      onTap: () => _showLanguageDialog(context),
                      delay: 0,
                    ),
                    const SizedBox(height: 16),
                    _buildSettingsCard(
                      icon: LucideIcons.shield,
                      title: 'privacy_policy'.tr(),
                      onTap: () => _launchPrivacyPolicy(),
                      delay: 1,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('select_language'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('english'.tr()),
              onTap: () {
                context.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
              trailing: context.locale == const Locale('en')
                  ? const Icon(Icons.check, color: Colors.black)
                  : null,
            ),
            ListTile(
              title: Text('amharic'.tr()),
              onTap: () {
                context.setLocale(const Locale('am'));
                Navigator.pop(context);
              },
              trailing: context.locale == const Locale('am')
                  ? const Icon(Icons.check, color: Colors.black)
                  : null,
            ),
            ListTile(
              title: Text('spanish'.tr()),
              onTap: () {
                context.setLocale(const Locale('es'));
                Navigator.pop(context);
              },
              trailing: context.locale == const Locale('es')
                  ? const Icon(Icons.check, color: Colors.black)
                  : null,
            ),
            ListTile(
              title: Text('german'.tr()),
              onTap: () {
                context.setLocale(const Locale('de'));
                Navigator.pop(context);
              },
              trailing: context.locale == const Locale('de')
                  ? const Icon(Icons.check, color: Colors.black)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchPrivacyPolicy() async {
    final url = Uri.parse(
      'https://miftah-fentaw.github.io/QR-code/privacy-policy.html',
    );
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch privacy policy')),
        );
      }
    }
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required int delay,
  }) {
    return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            onTap: onTap,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.black, size: 22),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            trailing: const Icon(
              LucideIcons.chevronRight,
              color: Colors.grey,
              size: 20,
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: (100 * delay).ms)
        .slideY(begin: 0.2, end: 0);
  }
}
