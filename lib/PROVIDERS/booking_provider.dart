import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingProvider extends ChangeNotifier {
  static const _storageKey = 'bookings';

  final List<Map<String, dynamic>> _bookings = [];

  List<Map<String, dynamic>> get bookings => List.unmodifiable(_bookings);

  BookingProvider() {
    _loadFromPrefs();
  }

  // ── Load saved bookings on app start ──
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_storageKey);
    if (raw != null) {
      final List<dynamic> decoded = jsonDecode(raw);
      for (final item in decoded) {
        final Map<String, dynamic> booking =
            Map<String, dynamic>.from(item as Map);
        // DateTime is stored as ISO string — convert back
        booking['date'] = DateTime.parse(booking['date'] as String);
        _bookings.add(booking);
      }
      notifyListeners();
    }
  }

  // ── Save current list to SharedPreferences ──
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // DateTime can't be JSON-encoded directly — convert to ISO string
    final encoded = _bookings.map((b) {
      final copy = Map<String, dynamic>.from(b);
      copy['date'] = (copy['date'] as DateTime).toIso8601String();
      return copy;
    }).toList();
    await prefs.setString(_storageKey, jsonEncode(encoded));
  }

  // ── Add a new booking ──
  Future<void> addBooking(Map<String, dynamic> booking) async {
    _bookings.add(booking);
    await _saveToPrefs();
    notifyListeners();
  }

  // ── Cancel a booking by index ──
  Future<void> cancelBooking(int index) async {
    _bookings[index]['status'] = 'Cancelled';
    await _saveToPrefs();
    notifyListeners();
  }
}