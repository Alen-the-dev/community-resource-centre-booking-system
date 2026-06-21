import 'package:flutter/material.dart';
import 'package:resource_hub/PAGES/home_page_content.dart';
import 'package:resource_hub/SCREENS/my_bookings_screen.dart'; 


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MainShellNavigationState();
}

class _MainShellNavigationState extends State<HomeScreen> {
  int _currentTabIndex = 0;

  final List<Widget> _appScreens = [
    const HomePageContent(), // Your original layout script profile
    const MyBookingsScreen(),
    const Center(child: Text('📤 Upload New Resource View', style: TextStyle(color: Color(0xFF64748B)))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _appScreens[_currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (int index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1A1A2E),
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.roofing_outlined, size: 22),
            activeIcon: Icon(Icons.roofing, size: 22),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined, size: 20),
            activeIcon: Icon(Icons.calendar_today, size: 20),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined, size: 22),
            activeIcon: Icon(Icons.add_box, size: 22),
            label: 'Upload',
          ),
        ],
      ),
    );
  }
}