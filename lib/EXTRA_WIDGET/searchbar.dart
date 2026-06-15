import 'package:flutter/material.dart';

class Searchbar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final TextEditingController controller;
  final String hintText;

  const Searchbar({
    super.key,
    required this.onChanged,
    required this.onClear,
    required this.controller,
    this.hintText = "Search rooms,sport fildes ,equipment, labs...",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B), size: 20),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Color(0xFF64748B), size: 18),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}