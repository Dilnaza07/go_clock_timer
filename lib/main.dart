import 'package:flutter/material.dart';
import 'core/di/init_module.dart';
import 'features/settings/presentation/screen/set_page.dart';
import 'features/timer_view/presentation/screen/clock_page.dart';

void main() {
  initMainModule();
  runApp(const ClockApp());
}

class ClockApp extends StatelessWidget {
  const ClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     // home: Settings2Page(),
   // home: TimerSettingsPage(),
     home: SettingsScreen(),

    );
  }
}




