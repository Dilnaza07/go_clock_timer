import 'package:flutter/material.dart';
import 'features/setings/presentation/screen/settings_page.dart';
import 'features/timer_view/presentation/screen/clock_page.dart';

void main() {
  runApp(const ClockApp());
}

class ClockApp extends StatelessWidget {
  const ClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     // home: TimerSettingsPage(),
      home: ClockPage(),
    );
  }
}




