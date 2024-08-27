import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
// ignore: unused_import
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  final DateTime selectedCalendarDate;
  final Function(DateTime) onDateSelected;

  const CalendarPage({Key? key, required this.selectedCalendarDate, required this.onDateSelected}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // border: Border.all(color: Theme.of(context).dividerColor, width: 1),
        // borderRadius: BorderRadius.circular(10),
      ),
      child: TableCalendar(
        focusedDay: widget.selectedCalendarDate,
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        selectedDayPredicate: (day) => isSameDay(day, widget.selectedCalendarDate),
        onDaySelected: (selectedDay, focusedDay) {
          widget.onDateSelected(selectedDay);
        },
        calendarFormat: CalendarFormat.month,
        onPageChanged: (focusedDay) {
          // Optionally handle page change
        },
      ),
    );
  }
}