import 'package:flutter/material.dart';

import 'features/start/presentation/screen/go_clock.dart';

void main() {
  runApp(const ClockApp());
}

class ClockApp extends StatelessWidget {
  const ClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GoClock(),
    );
  }
}




