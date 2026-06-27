import 'package:flutter/material.dart';

String formatDate(DateTime date) {
  const months = [
    '',
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[date.month]} ${date.day}, ${date.year}';
}

Color statusColor(String status) {
  switch (status) {
    case 'Upcoming':
      return const Color(0xFF15803D);
    case 'Pending':
      return const Color(0xFFD97706);
    case 'Cancelled':
      return const Color(0xFFDC2626);
    case 'Checked In':
      return const Color(0xFF2563EB);
    default:
      return const Color(0xFF6D28D9);
  }
}