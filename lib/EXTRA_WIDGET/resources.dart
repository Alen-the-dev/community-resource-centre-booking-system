import 'package:flutter/material.dart';

class ResourceCard extends StatelessWidget {
  final String title;
  final String location;
  final String capacity;
  final String category;
  final String resourcePic;
  final VoidCallback onTap;

  const ResourceCard({
    super.key,
    required this.title,
    required this.location,
    required this.capacity,
    required this.category,
    required this.resourcePic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Generate an automatic semantic UI accent match based on the item category context
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
            // Dynamic Network Image Container Area with fallback error scaffolding
            Container(
              height: 140, // Expanded slightly for better visual presentation of network layouts
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(
                  image: NetworkImage(resourcePic),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Smooth overlay dim gradient to ensure text readability matching material specs
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
            
            // Text Details Panel Information Structure
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
                      const Icon(Icons.location_on_outlined, color: Color(0xFF94A3B8), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                      ),
                      const Spacer(),
                      const Icon(Icons.people_outline, color: Color(0xFF94A3B8), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Cap: $capacity',
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
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