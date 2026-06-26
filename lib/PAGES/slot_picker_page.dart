import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resource_hub/mycolors.dart';
import 'package:resource_hub/PAGES/booking_confirmation_page.dart';
import 'package:resource_hub/PROVIDERS/booking_provider.dart';

class SlotPickerPage extends StatefulWidget {
  final Map<String, dynamic> resource;

  const SlotPickerPage({super.key, required this.resource});

  @override
  State<SlotPickerPage> createState() => _SlotPickerPageState();
}

class _SlotPickerPageState extends State<SlotPickerPage> {
  // Default to today so date is always "already picked"
  DateTime _selectedDate = DateTime.now();
  String? _selectedSlot;
  int _selectedDuration = 1;

  final List<String> _allSlots = [
    '8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM',
  ];

  final List<int> _durations = [1, 2, 3];

  // ── Returns booked slot strings for this resource on the selected date ──
  Set<String> _getBusySlots(List<Map<String, dynamic>> bookings) {
    final String dateKey = _dateKey(_selectedDate);
    final String resourceTitle = widget.resource['title'];

    return bookings
        .where((b) =>
            b['title'] == resourceTitle &&
            b['status'] != 'Cancelled' &&
            _dateKey(b['date'] as DateTime) == dateKey)
        .map((b) {
          // slot is stored as "9:00 AM – 11:00 AM", extract start time only
          final String slot = b['slot'] as String;
          return slot.split(' – ').first.trim();
        })
        .toSet();
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month}-${date.day}';

  // ── End time calculator ──
  String _calculateEndTime(String startTime, int hours) {
    final parts = startTime.split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);
    final String period = parts[1];

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;
    hour += hours;

    String newPeriod = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    final String minuteStr = minute.toString().padLeft(2, '0');
    return '$hour:$minuteStr $newPeriod';
  }

  String get _formattedSlot {
    if (_selectedSlot == null) return '';
    final end = _calculateEndTime(_selectedSlot!, _selectedDuration);
    return '$_selectedSlot – $end';
  }

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingProvider>().bookings;
    final busySlots = _getBusySlots(bookings);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Mycolors.primary,
        title: const Text('Pick Date & Time',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Month navigation ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_monthName(_selectedDate.month)} ${_selectedDate.year}',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B)),
              ),
              Row(
                children: [
                  _navBtn(Icons.chevron_left, () {
                    setState(() {
                      _selectedDate = DateTime(
                          _selectedDate.year, _selectedDate.month - 1, 1);
                      _selectedSlot = null;
                    });
                  }),
                  const SizedBox(width: 6),
                  _navBtn(Icons.chevron_right, () {
                    setState(() {
                      _selectedDate = DateTime(
                          _selectedDate.year, _selectedDate.month + 1, 1);
                      _selectedSlot = null;
                    });
                  }),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCalendar(busySlots),
          const SizedBox(height: 8),

          // ── Legend ──
          Row(
            children: [
              _legendItem(const Color(0xFFDCFCE7), 'Available'),
              const SizedBox(width: 12),
              _legendItem(const Color(0xFF1A1A2E), 'Selected'),
            ],
          ),
          const SizedBox(height: 16),

          // ── Time slots ──
          const Text('AVAILABLE TIME SLOTS',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF94A3B8),
                  letterSpacing: 0.8)),
          const SizedBox(height: 10),
          _buildSlotGrid(busySlots),
          const SizedBox(height: 20),

          // ── Duration picker ──
          if (_selectedSlot != null) ...[
            const Text('SELECT DURATION',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 0.8)),
            const SizedBox(height: 10),
            _buildDurationChips(),
            const SizedBox(height: 16),

            // ── Booking summary preview ──
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time_outlined,
                      color: Colors.white60, size: 18),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your booking slot',
                          style: TextStyle(
                              fontSize: 11, color: Colors.white60)),
                      const SizedBox(height: 2),
                      Text(
                        _formattedSlot,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$_selectedDuration hr${_selectedDuration > 1 ? 's' : ''}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── Confirm button ──
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedSlot == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingConfirmationPage(
                            resource: widget.resource,
                            selectedDate: _selectedDate,
                            selectedSlot: _formattedSlot,
                            duration: _selectedDuration,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Mycolors.primary,
                disabledBackgroundColor: const Color(0xFFE2E8F0),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                _selectedSlot == null
                    ? 'Select a time slot'
                    : 'Confirm Slot →',
                style: TextStyle(
                  color: _selectedSlot == null
                      ? const Color(0xFF94A3B8)
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDurationChips() {
    return Row(
      children: _durations.map((hrs) {
        final bool isSelected = _selectedDuration == hrs;
        return GestureDetector(
          onTap: () => setState(() => _selectedDuration = hrs),
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF1A1A2E)
                    : const Color(0xFFE2E8F0),
                width: 1.5,
              ),
            ),
            child: Text(
              '$hrs hr${hrs > 1 ? 's' : ''}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color:
                    isSelected ? Colors.white : const Color(0xFF334155),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendar(Set<String> busySlots) {
    final firstDay =
        DateTime(_selectedDate.year, _selectedDate.month, 1);
    final daysInMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7;
    const dayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)
        ],
      ),
      child: Column(
        children: [
          Row(
            children: dayLabels
                .map((d) => Expanded(
                      child: Text(d,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 9,
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w600)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: startWeekday + daysInMonth,
            itemBuilder: (context, index) {
              if (index < startWeekday) return const SizedBox();
              final day = index - startWeekday + 1;
              final thisDate = DateTime(
                  _selectedDate.year, _selectedDate.month, day);
              final isSelected = _selectedDate.day == day &&
                  _selectedDate.month == thisDate.month;
              final now = DateTime.now();
              final isToday = now.day == day &&
                  now.month == _selectedDate.month &&
                  now.year == _selectedDate.year;
              final isPast = thisDate
                  .isBefore(DateTime(now.year, now.month, now.day));

              Color bgColor;
              Color textColor;

              if (isSelected) {
                bgColor = const Color(0xFF1A1A2E);
                textColor = Colors.white;
              } else if (isPast) {
                bgColor = const Color(0xFFF1F5F9);
                textColor = const Color(0xFFCBD5E1);
              } else {
                bgColor = const Color(0xFFDCFCE7);
                textColor = const Color(0xFF15803D);
              }

              return GestureDetector(
                onTap: isPast
                    ? null
                    : () => setState(() {
                          _selectedDate = thisDate;
                          _selectedSlot = null;
                        }),
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday
                        ? Border.all(
                            color: const Color(0xFF818CF8), width: 1.5)
                        : null,
                  ),
                  child: Center(
                    child: Text('$day',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: textColor)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSlotGrid(Set<String> busySlots) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: _allSlots.length,
      itemBuilder: (context, index) {
        final String slotTime = _allSlots[index];
        final bool isBusy = busySlots.contains(slotTime);
        final bool isSelected = _selectedSlot == slotTime;

        return GestureDetector(
          onTap: isBusy
              ? null
              : () => setState(() {
                    _selectedSlot = slotTime;
                    _selectedDuration = 1;
                  }),
          child: Container(
            decoration: BoxDecoration(
              color: isBusy
                  ? const Color(0xFFFEE2E2)
                  : isSelected
                      ? const Color(0xFF1A1A2E)
                      : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isBusy
                    ? const Color(0xFFFECACA)
                    : isSelected
                        ? const Color(0xFF1A1A2E)
                        : const Color(0xFFE2E8F0),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                isBusy ? '🔒 $slotTime' : slotTime,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isBusy
                      ? const Color(0xFFB91C1C)
                      : isSelected
                          ? Colors.white
                          : const Color(0xFF334155),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF334155)),
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 4),
        Text(label,
            style:
                const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];
    return months[month];
  }
}