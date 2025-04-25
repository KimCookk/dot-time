import 'package:dot_time/feature/home/provider/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  DateTime? _setDate;
  DateTime? _setTime;
  int? _setAlarmIntervalPercent;

  void _pickDate() {
    DatePicker.showDatePicker(
      context,
      currentTime: _setDate,
      showTitleActions: true,
      locale: LocaleType.ko,
      onChanged: (date) {},
      onConfirm: (date) {
        setState(() {
          _setDate = date;
        });
      },
    );
  }

  void _pickTime() {
    DatePicker.showTimePicker(
      context,
      currentTime: _setTime,
      showTitleActions: true,
      locale: LocaleType.ko,
      showSecondsColumn: false,
      onChanged: (time) {
        print('change $time');
      },
      onConfirm: (time) {
        setState(() {
          _setTime = time;
        });
      },
    );
  }

  void _selectSetAlarmIntervalPercent(int setAlarmIntervalPercent) {
    setState(() {
      _setAlarmIntervalPercent = setAlarmIntervalPercent;
    });
  }

  void _saveSettings() {
    // TODO: 저장 로직 연동 (예: Provider, SharedPreferences 등)
    if (_setDate != null && _setTime != null) {
      context.read<HomeState>().setTargetDateTime(
            DateTime(
              _setDate!.year,
              _setDate!.month,
              _setDate!.day,
              _setTime!.hour,
              _setTime!.minute,
            ),
          );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeState>();
    final DateTime dateTime = state.targetDateTime;

    _setDate = _setDate ??
        DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
        );

    _setTime = _setTime ??
        DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
        );

    _setAlarmIntervalPercent =
        _setAlarmIntervalPercent ?? state.alarmIntervalPercent;

    final dateStr = DateFormat('yyyy-MM-dd').format(_setDate!);
    final timeStr = DateFormat('HH:mm').format(_setTime!);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 28,
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Target date',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      dateStr,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Target time',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      timeStr,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Alarm Frequency ( percent )',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              width: 200,
              child: DropdownButtonFormField<int>(
                value: _setAlarmIntervalPercent,
                dropdownColor: Colors.grey,
                iconEnabledColor: Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                //isExpanded: true,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                items: [1, 5, 10, 25]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Container(
                            width: 100,
                            child: Text('$e'),
                          ),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) _selectSetAlarmIntervalPercent(val);
                },
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _saveSettings,
                child: const Text('Save', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
