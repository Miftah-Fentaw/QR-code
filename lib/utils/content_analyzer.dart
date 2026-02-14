import 'package:url_launcher/url_launcher.dart';

class ContentAnalyzer {
  /// Validates if a string is a valid URL
  static bool isValidUrl(String text) {
    try {
      final uri = Uri.parse(text);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      // Try adding https:// if no scheme
      try {
        final uri = Uri.parse('https://$text');
        return uri.hasAuthority;
      } catch (e) {
        return false;
      }
    }
  }

  /// Validates if a string is a phone number
  static bool isPhoneNumber(String text) {
    final phonePattern = RegExp(r'^\+?[\d\s\-\(\)]{7,}$');
    return phonePattern.hasMatch(text.trim());
  }

  /// Validates if a string is an email
  static bool isEmail(String text) {
    final emailPattern = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    return emailPattern.hasMatch(text.trim());
  }

  /// Formats a phone number by removing spaces and special characters
  static String formatPhoneNumber(String phone) {
    // Remove all non-digit characters except '+'
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }

  /// Ensures URL has proper scheme
  static String ensureUrlScheme(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    return url;
  }

  /// Launches a URL in the browser
  static Future<bool> launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(ensureUrlScheme(url));
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      return false;
    }
  }

  /// Launches phone dialer
  static Future<bool> launchPhone(String phone) async {
    try {
      final formattedPhone = formatPhoneNumber(phone);
      final Uri uri = Uri.parse('tel:$formattedPhone');
      return await launchUrl(uri);
    } catch (e) {
      return false;
    }
  }

  /// Launches email client
  static Future<bool> launchEmail(String email) async {
    try {
      final Uri uri = Uri.parse('mailto:$email');
      return await launchUrl(uri);
    } catch (e) {
      return false;
    }
  }

  /// Launches Google search for the given text
  static Future<bool> searchOnGoogle(String query) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final Uri uri = Uri.parse(
        'https://www.google.com/search?q=$encodedQuery',
      );
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      return false;
    }
  }
}
