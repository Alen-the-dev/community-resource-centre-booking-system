import 'dart:convert';
import 'package:flutter/material.dart';

/// Displays a resource image from either a base64 string or a URL.
/// Pass [fit], [width], [height] as needed.
class ResourceImage extends StatelessWidget {
  final Map<String, dynamic> resource;
  final BoxFit fit;
  final double? width;
  final double? height;

  const ResourceImage({
    super.key,
    required this.resource,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final String? pic = resource['resourcePic'];
    final bool isBase64 = resource['isBase64'] == true;

    if (pic == null || pic.isEmpty) return _fallback();

    if (isBase64) {
      try {
        final bytes = base64Decode(pic);
        return Image.memory(
          bytes,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (_, _, _) => _fallback(),
        );
      } catch (_) {
        return _fallback();
      }
    }

    return Image.network(
      pic,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, _, _) => _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFEDE9FE),
      child: const Center(
        child: Icon(Icons.meeting_room_outlined,
            color: Color(0xFF6D28D9), size: 32),
      ),
    );
  }
}