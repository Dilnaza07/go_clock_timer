import 'package:flutter/material.dart';
import 'core/di/init_module.dart';
import 'features/settings/presentation/screen/settings_page.dart';

void main() {
  initMainModule();
  runApp(const ClockApp());
}

class ClockApp extends StatelessWidget {
  const ClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     home: SettingsScreen(),

    );
  }
}




