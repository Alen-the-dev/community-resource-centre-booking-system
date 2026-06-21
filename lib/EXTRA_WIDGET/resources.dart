import 'package:flutter/material.dart';

class Resources extends StatelessWidget {
  final Map<String, dynamic> resource;
  final VoidCallback onTap;

  const Resources({
    super.key,
    required this.resource,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String title = resource['title'] ?? 'Unknown';
    final String location = resource['location'] ?? '';
    final String capacity = resource['capacity'] ?? '';
    final String category = resource['category'] ?? '';
    final String? pic = resource['resourcePic'];

    final Color themeColor = category == 'Rooms'
        ? const Color(0xFF4F46E5)
        : const Color(0xFF0EA5E9);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (pic != null && pic.isNotEmpty)
                    Image.network(
                      pic,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.image_not_supported,
                            color: Color(0xFF94A3B8), size: 36),
                      ),
                    )
                  else
                    const Center(
                      child: Icon(Icons.image_not_supported,
                          color: Color(0xFF94A3B8), size: 36),
                    ),
                  // Category badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category.toUpperCase(),
                        style: TextStyle(
                          color: themeColor,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: Color(0xFF94A3B8), size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                              color: Color(0xFF64748B), fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.people_outline,
                          color: Color(0xFF94A3B8), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Cap: $capacity',
                        style: const TextStyle(
                            color: Color(0xFF64748B), fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}