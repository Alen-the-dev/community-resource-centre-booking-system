import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resource_hub/PROVIDERS/booking_provider.dart';
import 'package:resource_hub/utils.dart';

class NfcSimulatorPage extends StatefulWidget {
  final Map<String, dynamic> booking;
  final int bookingIndex;

  const NfcSimulatorPage({
    super.key,
    required this.booking,
    required this.bookingIndex,
  });

  @override
  State<NfcSimulatorPage> createState() => _NfcSimulatorPageState();
}

class _NfcSimulatorPageState extends State<NfcSimulatorPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _pulseAnim;

  // ── Scan states ──
  bool _isScanning = true;
  bool _success = false;
  String _failReason = '';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    // Start validation after 2 seconds (simulates scanning)
    Future.delayed(const Duration(seconds: 2), _validate);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ── Parse slot start time into hour (24hr) ──
  int _slotStartHour(String slot) {
    // slot format: "11:00 AM – 1:00 PM"
    final startStr = slot.split(' – ').first.trim();
    final parts = startStr.split(' ');
    int hour = int.parse(parts[0].split(':')[0]);
    final period = parts[1];
    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;
    return hour;
  }

  void _validate() {
    final Map<String, dynamic> booking = widget.booking;
    final DateTime bookingDate = booking['date'] as DateTime;
    final String slot = booking['slot'] as String;
    final int duration = booking['duration'] as int;
    final now = DateTime.now();

    // ── Check 1: Is today the booking date? ──
    final bool isToday = now.year == bookingDate.year &&
        now.month == bookingDate.month &&
        now.day == bookingDate.day;

    if (!isToday) {
      setState(() {
        _isScanning = false;
        _success = false;
        _failReason =
            'Your booking is for ${formatDate(bookingDate)}, not today.';
      });
      _animController.stop();
      return;
    }

    // ── Check 2: Is current time within the booking slot? ──
    final int startHour = _slotStartHour(slot);
    final int endHour = startHour + duration;
    final int currentHour = now.hour;

    if (currentHour < startHour) {
      final int minsUntil = (startHour - currentHour) * 60 - now.minute;
      setState(() {
        _isScanning = false;
        _success = false;
        _failReason =
            'Too early. Your slot starts in ${minsUntil}min. Come back at ${slot.split(' – ').first}.';
      });
      _animController.stop();
      return;
    }

    if (currentHour >= endHour) {
      setState(() {
        _isScanning = false;
        _success = false;
        _failReason =
            'Your slot has already ended. Booking was ${slot.split(' – ').first} – ${slot.split(' – ').last}.';
      });
      _animController.stop();
      return;
    }

    // ── All checks passed ──
    setState(() {
      _isScanning = false;
      _success = true;
    });
    _animController.stop();

    // Mark as checked in
    context.read<BookingProvider>().checkIn(widget.bookingIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        title: const Text('NFC Check-in',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ── Resource info ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.booking['title'],
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '📍 ${widget.booking['location']}  •  🕐 ${widget.booking['slot']}',
                    style: const TextStyle(
                        color: Colors.white60, fontSize: 12),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ── Scanning animation / result ──
            if (_isScanning) _buildScanning(),
            if (!_isScanning && _success) _buildSuccess(),
            if (!_isScanning && !_success) _buildFailure(),

            const Spacer(),

            // ── Bottom button ──
            if (!_isScanning)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _success
                        ? const Color(0xFF15803D)
                        : const Color(0xFFDC2626),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    _success ? 'Done' : 'Go Back',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildScanning() {
    return Column(
      children: [
        // ── Pulse rings ──
        ScaleTransition(
          scale: _pulseAnim,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 2),
            ),
            child: Center(
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white38, width: 2),
                ),
                child: Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF6D28D9),
                    ),
                    child: const Icon(Icons.nfc_outlined,
                        color: Colors.white, size: 40),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        const Text('Scanning NFC tag...',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Hold your phone near the entrance reader',
            style: TextStyle(color: Colors.white54, fontSize: 13)),
      ],
    );
  }

  Widget _buildSuccess() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF15803D).withValues(alpha: 0.15),
            border: Border.all(color: const Color(0xFF15803D), width: 2),
          ),
          child: const Icon(Icons.check_rounded,
              color: Color(0xFF15803D), size: 60),
        ),
        const SizedBox(height: 24),
        const Text('Check-in Successful!',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Your usage has been confirmed.\nEnjoy your session!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 13)),
        const SizedBox(height: 16),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF15803D).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Status → Checked In',
            style: TextStyle(
                color: statusColor('Checked In'),
                fontWeight: FontWeight.w700,
                fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildFailure() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFDC2626).withValues(alpha: 0.15),
            border: Border.all(color: const Color(0xFFDC2626), width: 2),
          ),
          child: const Icon(Icons.close_rounded,
              color: Color(0xFFDC2626), size: 60),
        ),
        const SizedBox(height: 24),
        const Text('Check-in Failed',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFDC2626).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xFFDC2626).withValues(alpha: 0.3)),
          ),
          child: Text(
            _failReason,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Color(0xFFFCA5A5), fontSize: 13, height: 1.5),
          ),
        ),
      ],
    );
  }
}