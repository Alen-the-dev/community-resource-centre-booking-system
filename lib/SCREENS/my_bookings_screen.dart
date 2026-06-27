import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resource_hub/EXTRA_WIDGET/booking_card.dart';
import 'package:resource_hub/EXTRA_WIDGET/booking_detail_sheet..dart';

import 'package:resource_hub/PROVIDERS/booking_provider.dart';
import 'package:resource_hub/mycolors.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingProvider>().bookings;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Mycolors.primary,
        title: const Text(
          'My Bookings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: bookings.isEmpty
          ? _emptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return BookingCard(
                  booking: booking,
                  onTap: () => showBookingDetailSheet(context, booking, index),
                );
              },
            ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined,
              size: 64, color: Color(0xFFCBD5E1)),
          SizedBox(height: 16),
          Text(
            'No bookings yet',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF94A3B8)),
          ),
          SizedBox(height: 6),
          Text(
            'Book a resource from the Home tab',
            style: TextStyle(fontSize: 13, color: Color(0xFFCBD5E1)),
          ),
        ],
      ),
    );
  }
}