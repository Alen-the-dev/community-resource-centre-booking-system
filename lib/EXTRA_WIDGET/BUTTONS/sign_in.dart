import 'package:flutter/material.dart';
import 'package:resource_hub/mycolors.dart';

class SignIn extends StatefulWidget {
  final VoidCallback? onPressed;

  const SignIn({super.key, this.onPressed});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: widget.onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Mycolors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
  }
}