import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String _username = 'loading...';
  List<Map<String, dynamic>> _shifts = [];
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _selectedDayShifts = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      if (token == null) {
        setState(() {
          _username = 'No token found';
        });
        return;
      }

      Map<String, dynamic> payload = Jwt.parseJwt(token);
      String username = payload['sub'] ?? '';

      final url = Uri.parse(
        'http://192.168.204.1:8080/users/username?username=$username',
      );

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final user = json.decode(response.body);
        final shifts = user['shifts'] as List;

        setState(() {
          _username = username;
          _shifts = shifts.cast<Map<String, dynamic>>();
          _selectedDay = null;
          _selectedDayShifts = [];
        });
      } else {
        setState(() {
          _username = 'Failed to load user';
        });
      }
    } catch (e) {
      setState(() {
        _username = 'Error loading user';
      });
    }
  }

  bool _hasShiftOn(DateTime day) {
    return _shifts.any((shift) {
      final shiftDate = DateTime.parse(shift['start']);
      return shiftDate.year == day.year &&
          shiftDate.month == day.month &&
          shiftDate.day == day.day;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    final selectedShifts = _shifts.where((shift) {
      final shiftDate = DateTime.parse(shift['start']);
      return shiftDate.year == selectedDay.year &&
          shiftDate.month == selectedDay.month &&
          shiftDate.day == selectedDay.day;
    }).toList();

    setState(() {
      _selectedDay = selectedDay;
      _selectedDayShifts = selectedShifts;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modern AppBar replacement
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.person,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Welcome, $_username',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: TableCalendar(
                      calendarFormat: _calendarFormat,
                      focusedDay: _selectedDay ?? DateTime.now(),
                      firstDay: DateTime.utc(2023),
                      lastDay: DateTime.utc(2030),
                      calendarStyle: CalendarStyle(
                        markerDecoration: BoxDecoration(
                          color: theme.colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        weekendTextStyle: TextStyle(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: theme.colorScheme.primary,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      selectedDayPredicate: (day) {
                        return _selectedDay != null &&
                            day.year == _selectedDay!.year &&
                            day.month == _selectedDay!.month &&
                            day.day == _selectedDay!.day;
                      },
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, day, events) {
                          if (_hasShiftOn(day)) {
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade300,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                      onDaySelected: _onDaySelected,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _selectedDay == null
                      ? Container()
                      : _selectedDayShifts.isNotEmpty
                      ? Column(
                          key: const ValueKey('shifts'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shifts on ${_selectedDay!.toLocal().toString().split(' ')[0]}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _selectedDayShifts.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final shift = _selectedDayShifts[index];
                                final start = DateTime.parse(shift['start']);
                                final end = DateTime.parse(shift['end']);
                                return Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          theme.colorScheme.primaryContainer,
                                      child: Icon(
                                        Icons.work,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    title: Text(
                                      'Shift: ${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}',
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                    subtitle: shift.containsKey('role')
                                        ? Text('Role: ${shift['role']}')
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : Padding(
                          key: const ValueKey('no-shifts'),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: theme.colorScheme.secondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'No shifts on ${_selectedDay!.toLocal().toString().split(' ')[0]}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loadUserData,
        icon: const Icon(Icons.refresh),
        label: const Text('Refresh'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }
}
