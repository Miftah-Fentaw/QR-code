import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';




// ==== Feature list ====
final features = [
  Feature(
    id: 'scan',
    title: 'Scan QR Code',
    description: 'Use your camera to scan any QR code instantly.',
    icon: LucideIcons.scan,
    gradient: [Colors.indigo, Colors.purple],
    bg: [Colors.white, Colors.white],
  ),
  Feature(
    id: 'generate',
    title: 'Generate QR Code',
    description: 'Create QR codes from text, URLs, or contact info.',
    icon: LucideIcons.qrCode,
    gradient: [Colors.teal, Colors.cyan],
    bg: [Colors.white, Colors.white],
  ),
  Feature(
    id: 'history',
    title: 'Scan History',
    description: 'View and manage your previously scanned codes.',
    icon: LucideIcons.clock,
    gradient: [Colors.orange, Colors.deepOrangeAccent],
    bg: [Colors.white, Colors.white],
  ),
  Feature(
    id: 'settings',
    title: 'Settings',
    description: 'Customize your app preferences and theme.',
    icon: LucideIcons.settings,
    gradient: [Colors.pinkAccent, Colors.redAccent],
    bg: [Colors.white, Colors.white],
  ),
];

class Feature {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final List<Color> bg;

  Feature({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.bg,
  });
}