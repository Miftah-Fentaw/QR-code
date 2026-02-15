import 'package:hive/hive.dart';

part 'code_data_model.g.dart';

@HiveType(typeId: 0)
enum CodeType {
  @HiveField(0)
  qr,
  @HiveField(1)
  barcode,
}

enum ContentType { url, phone, email, plainText }

class CodeData {
  final CodeType codeType;
  final String content;
  final DateTime timestamp;
  final ContentType contentType;

  CodeData({
    required this.codeType,
    required this.content,
    DateTime? timestamp,
    ContentType? contentType,
  }) : timestamp = timestamp ?? DateTime.now(),
       contentType = contentType ?? ContentType.plainText;

  // Create from scanned/generated data
  factory CodeData.fromContent({
    required String content,
    required CodeType codeType,
  }) {
    return CodeData(
      content: content,
      codeType: codeType,
      timestamp: DateTime.now(),
      contentType: _detectContentType(content),
    );
  }

  // Detect content type based on content
  static ContentType _detectContentType(String content) {
    // Check if it's a URL
    final urlPattern = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );
    if (urlPattern.hasMatch(content)) {
      return ContentType.url;
    }

    // Check if it's a phone number
    final phonePattern = RegExp(r'^\+?[\d\s\-\(\)]{7,}$');
    if (phonePattern.hasMatch(content.trim())) {
      return ContentType.phone;
    }

    // Check if it's an email
    final emailPattern = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (emailPattern.hasMatch(content.trim())) {
      return ContentType.email;
    }

    // Default to plain text
    return ContentType.plainText;
  }

  // Copy with method for modifications
  CodeData copyWith({
    CodeType? codeType,
    String? content,
    DateTime? timestamp,
    ContentType? contentType,
  }) {
    return CodeData(
      codeType: codeType ?? this.codeType,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      contentType: contentType ?? this.contentType,
    );
  }

  @override
  String toString() {
    return 'CodeData(type: $codeType, contentType: $contentType, content: $content)';
  }
}
