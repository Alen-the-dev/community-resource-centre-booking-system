import 'package:flutter/material.dart';

class CustomContainer extends StatefulWidget {
  final String hintText;
  final IconData hintIcon;
  final bool isPassword;

  const CustomContainer({
    super.key,
    required this.hintText,
    required this.hintIcon,
    this.isPassword = false, // default false
  });

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  bool _obscure = true; // for password toggle

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        obscureText: widget.isPassword ? _obscure : false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          prefixIcon: Icon(widget.hintIcon, color: const Color(0xFF94A3B8)),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF818CF8), width: 1.5),
          ),
          // 👁 show/hide toggle for password
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF94A3B8),
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                )
              : null,
        ),
      ),
    );
  }
}
