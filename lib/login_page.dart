import 'package:flutter/material.dart';
import 'package:resource_hub/EXTRA_WIDGET/BUTTONS/create_account.dart';
import 'package:resource_hub/EXTRA_WIDGET/BUTTONS/sign_in.dart';
import 'package:resource_hub/EXTRA_WIDGET/custom_container.dart';
import 'package:resource_hub/mycolors.dart';
import 'package:resource_hub/PAGES/home_screen.dart'; // 👈 Added PAGES/

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(backgroundColor: Mycolors.primary, elevation: 0),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Section ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 32, top: 20),
              decoration: BoxDecoration(color: Mycolors.primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.book_online,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white60,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Resource Centre",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Book rooms, grounds & equipment easily",
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email
                  const Text(
                    "EMAIL ADDRESS",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  CustomContainer(
                    hintText: "user@example.com",
                    hintIcon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 16),

                  // Password
                  const Text(
                    "PASSWORD",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  CustomContainer(
                    hintText: "••••••••",
                    hintIcon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF818CF8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Sign In Trigger Wrap
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    },
                    child: const SignIn(),
                  ),

                  const SizedBox(height: 12),

                  // Create Account Trigger Wrap
                  GestureDetector(
                    onTap: () {
                      // Optional: Link to a registration page here if needed
                    },
                    child: const CreateAccount(),
                  ),
                  
                  const SizedBox(height: 24),

                  // Footer
                  const Center(
                    child: Text(
                      "Ardhi University · Project 25",
                      style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}