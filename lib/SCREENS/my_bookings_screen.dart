import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          'MyBookingsScreen Bookings',
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
                return _bookingCard(context, booking);
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

  Widget _bookingCard(BuildContext context, Map<String, dynamic> booking) {
    final DateTime date = booking['date'];
    final String formattedDate = _formatDate(date);
    final String imageUrl = booking['resourcepic'] ?? '';

    return GestureDetector(
      onTap: () => _showBookingDetail(context, booking),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Resource image ──
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imageFallback(),
                    )
                  : _imageFallback(),
            ),

            // ── Content ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            booking['title'],
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _statusColor(booking['status']).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            booking['status'],
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: _statusColor(booking['status'])),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '📍 ${booking['location']}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF94A3B8)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 11, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Text(formattedDate,
                            style: const TextStyle(
                                fontSize: 11, color: Color(0xFF64748B))),
                        const SizedBox(width: 10),
                        const Icon(Icons.access_time_outlined,
                            size: 11, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Text(booking['slot'],
                            style: const TextStyle(
                                fontSize: 11, color: Color(0xFF64748B))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Text(
                          'Tap to view details',
                          style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6D28D9),
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios,
                            size: 10, color: Color(0xFF6D28D9)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDetail(BuildContext context, Map<String, dynamic> booking) {
    final DateTime date = booking['date'];
    final String imageUrl = booking['resourcepic'] ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            // ── Image ──
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _imageFallback(height: 160),
                    )
                  : _imageFallback(height: 160),
            ),

            const SizedBox(height: 16),

            // ── Title + status ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking['title'],
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B)),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: _statusColor(booking['status']).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    booking['status'],
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _statusColor(booking['status'])),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '📍 ${booking['location']}',
                style:
                    const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: Color(0xFFF1F5F9)),
            const SizedBox(height: 12),

            // ── Detail rows ──
            _detailRow(Icons.calendar_today_outlined, 'Date',
                _formatDate(date)),
            _detailRow(Icons.access_time_outlined, 'Time Slot',
                booking['slot']),
            _detailRow(Icons.timelapse_outlined, 'Duration', '1 hour'),
            _detailRow(Icons.attach_money_outlined, 'Fee', 'Free'),
            _detailRow(Icons.nfc_outlined, 'Check-in',
                'NFC tap required at entrance'),

            const SizedBox(height: 20),

            // ── Close button ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Mycolors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Close',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 10),
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF94A3B8))),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _imageFallback({double height = 100}) {
    return Container(
      width: height == 100 ? 100 : double.infinity,
      height: height,
      color: const Color(0xFFEDE9FE),
      child: const Icon(Icons.meeting_room_outlined,
          color: Color(0xFF6D28D9), size: 32),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Upcoming':
        return const Color(0xFF15803D);
      case 'Pending':
        return const Color(0xFFD97706);
      case 'Cancelled':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF6D28D9);
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      '',
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month]} ${date.day}, ${date.year}';
  }
}