import 'package:flutter/material.dart';
import 'package:resource_hub/mycolors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Mycolors.primary,
        elevation: 0,
        automaticallyImplyLeading: false, // removes back arrow
        title: Row(
          children: [
            // Left side — greeting
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good morning ",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "Hello, John",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),

            Spacer(), 

            // Right side — avatar
            CircleAvatar(
              backgroundColor: const Color(0xFF818CF8),
              child: Text(
                "J",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}