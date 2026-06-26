import 'package:flutter/material.dart';
import 'package:resource_hub/mycolors.dart';
import 'package:resource_hub/utils.dart';

void showBookingDetailSheet(
    BuildContext context, Map<String, dynamic> booking) {
  final DateTime date = booking['date'];
  final String imageUrl = booking['resourcePic'] ?? '';
  final int duration = booking['duration'] as int;

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
          // ── Handle bar ──
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
                    errorBuilder: (_, _, _) => _imageFallback(),
                  )
                : _imageFallback(),
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
                  color: statusColor(booking['status']).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  booking['status'],
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: statusColor(booking['status'])),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '📍 ${booking['location']}',
              style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // ── Detail rows ──
          _detailRow(Icons.calendar_today_outlined, 'Date', formatDate(date)),
          _detailRow(Icons.access_time_outlined, 'Time Slot', booking['slot']),
          _detailRow(Icons.timelapse_outlined, 'Duration',
              '$duration hr${duration > 1 ? 's' : ''}'),
          _detailRow(Icons.attach_money_outlined, 'Fee', 'Free'),
          _detailRow(
              Icons.nfc_outlined, 'Check-in', 'NFC tap required at entrance'),

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
            style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
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

Widget _imageFallback() {
  return Container(
    width: double.infinity,
    height: 160,
    color: const Color(0xFFEDE9FE),
    child: const Icon(Icons.meeting_room_outlined,
        color: Color(0xFF6D28D9), size: 32),
  );
}