import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _bookings = [];

  List<Map<String, dynamic>> get bookings => List.unmodifiable(_bookings);

  void addBooking(Map<String, dynamic> booking) {
    _bookings.add(booking);
    notifyListeners(); // 👈 this tells all listening screens to rebuild
  }
}