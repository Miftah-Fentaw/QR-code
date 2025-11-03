import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qrcode/utils/utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  

  @override
  Widget build(BuildContext context) {
    final feature = features.firstWhere((f) => f.id == 'settings');

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
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height, // fill screen
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Header
                    Column(
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
                        const SizedBox(height: 25),
                      ],
                    ),

                    // Settings Options
                    Column(
                      children: [
                        // Dark Mode Toggle
                        Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        LucideIcons.moon,
                                        color: Colors.black54,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Dark Mode',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Switch(
                                    value: _darkMode,
                                    onChanged: (value) {
                                      setState(() {
                                        _darkMode = value;
                                      });
                                    },
                                    activeColor: Colors.pinkAccent,
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slideY(begin: 0.2, end: 0),

                        const SizedBox(height: 10),

                        // Auto Save Toggle
                        Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        LucideIcons.star,
                                        color: Colors.black54,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Rate us',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(onPressed: (){}, icon: Icon(LucideIcons.arrowRight))
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slideY(begin: 0.3, end: 0),

                        const SizedBox(height: 10),

                        // Theme Selector
                        Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        LucideIcons.externalLink,
                                        color: Colors.black54,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Other Apps',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(onPressed: (){}, icon: Icon(LucideIcons.appWindow))
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slideY(begin: 0.4, end: 0),

                        const SizedBox(height: 20),

                        // Save Settings Button
                        
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
