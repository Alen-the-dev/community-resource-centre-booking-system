import 'package:flutter/material.dart';
import 'package:resource_hub/EXTRA_WIDGET/BUTTONS/create_account.dart';
import 'package:resource_hub/EXTRA_WIDGET/BUTTONS/sign_in.dart';
import 'package:resource_hub/EXTRA_WIDGET/custom_container.dart';
import 'package:resource_hub/mycolors.dart';
import 'package:resource_hub/PAGES/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSignUp = false; // false = Sign In mode, true = Create Account mode
  bool _loading = false;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

 Future<void> _handleCreateAccount() async {
  final firstName = _firstNameController.text.trim();
  final lastName = _lastNameController.text.trim();
  final email = _emailController.text.trim();
  final password = _passwordController.text;

  if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
    _showError("Fill in first name, last name, email and password.");
    return;
  }

  setState(() => _loading = true);
  try {
    await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
      data: {'first_name': firstName, 'last_name': lastName},
    );
  } catch (e) {
    setState(() => _loading = false);
    _showError(e.toString());
    return;
  }
  setState(() => _loading = false);
  if (!mounted) return;
  _goHome();
}

Future<void> _handleSignIn() async {
  final email = _emailController.text.trim();
  final password = _passwordController.text;

  setState(() => _loading = true);
  try {
    await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  } catch (e) {
    setState(() => _loading = false);
    _showError("Wrong email or password.");
    return;
  }
  setState(() => _loading = false);
  if (!mounted) return;
  _goHome();
}

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
                      Icons.account_balance,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _isSignUp ? "Get Started" : "Welcome",
                    style: const TextStyle(
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
                  if (_isSignUp) ...[
                    const Text(
                      "FIRST NAME",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomContainer(
                      hintText: "Jane",
                      hintIcon: Icons.person_outline,
                      controller: _firstNameController,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      "LAST NAME",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomContainer(
                      hintText: "Doe",
                      hintIcon: Icons.person_outline,
                      controller: _lastNameController,
                    ),
                    const SizedBox(height: 16),
                  ],

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
                    controller: _emailController,
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
                    controller: _passwordController,
                  ),

                  if (!_isSignUp)
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

                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    // Primary action: Sign In or Create Account depending on mode
                    _isSignUp
                        ? CreateAccount(onPressed: _handleCreateAccount)
                        : SignIn(onPressed: _handleSignIn),

                    const SizedBox(height: 12),

                    // Toggle between modes
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSignUp = !_isSignUp;
                        });
                      },
                      child: Center(
                        child: Text(
                          _isSignUp
                              ? "Already have an account? Sign In"
                              : "New here? Create Account",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF818CF8),
                          ),
                        ),
                      ),
                    ),
                  ],

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
