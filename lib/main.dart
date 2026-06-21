import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resource_hub/PROVIDERS/booking_provider.dart';
import 'package:resource_hub/login_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BookingProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}