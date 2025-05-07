import 'package:dot_time/feature/home/provider/home_state.dart';
import 'package:dot_time/feature/setting/provider/setting_state.dart';
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
  void _pickDate() {
    SettingState state = context.read<SettingState>();
    DateTime setDate = state.targetDateTime;

    DatePicker.showDatePicker(
      context,
      currentTime: setDate,
      showTitleActions: true,
      locale: LocaleType.ko,
      onChanged: (date) {},
      onConfirm: (date) {
        context.read<SettingState>().setTargetDate(date);
      },
    );
  }

  void _pickTime() {
    SettingState state = context.read<SettingState>();
    DateTime setTime = state.targetDateTime;

    DatePicker.showTimePicker(
      context,
      currentTime: setTime,
      showTitleActions: true,
      locale: LocaleType.ko,
      showSecondsColumn: false,
      onChanged: (time) {
        print('change $time');
      },
      onConfirm: (time) {
        state.setTargetTime(time);
      },
    );
  }

  void _saveSettings() {
    SettingState state = context.read<SettingState>();
    Map<String, dynamic> setting = state.save();
    HomeState homeState = context.read<HomeState>();
    homeState.setTargetDateTime(setting['targetDateTime']);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    SettingState state = context.watch<SettingState>();

    final dateStr = DateFormat('yyyy-MM-dd').format(state.targetDateTime);
    final timeStr = DateFormat('HH:mm').format(state.targetDateTime);
    final alarmIntervalPercent = state.alarmIntervalPercent;

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
                value: alarmIntervalPercent,
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
                  if (val != null)
                    context.read<SettingState>().setAlarmIntervalPercent(val);
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
