import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:resource_hub/PROVIDERS/booking_provider.dart';
import 'package:resource_hub/PROVIDERS/resource_provider.dart';
import 'package:resource_hub/login_page.dart';
import 'package:resource_hub/PAGES/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
Future<void> main() async {
  await Supabase.initialize(
  url: 'https://jbpzikjngeacikouuahp.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpicHppa2puZ2VhY2lrb3V1YWhwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI5MjYwNDIsImV4cCI6MjA5ODUwMjA0Mn0.OCpzQ1gkvGpT9lSrISTlkwV_MQYzH-V3pHCc3nW_IT4',
);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ResourceProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return (snapshot.data ?? false) ? const HomeScreen() : const LoginPage();
        },
      ),
    );
  }
}