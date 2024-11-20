import 'package:flutter/material.dart';


class Settings2Page extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<Settings2Page> {
  String selectedTime = '3 Minutes';
  String selectedIncrement = 'No Increment';
  String selectedDelay = '2 Seconds';
  String selectedTimeBars = 'Invisible';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSettingOption(
              title: 'Time',
              description:
              'The time each player is given for the entire game. When a player\'s time reaches zero, the game is lost.',
              value: selectedTime,
              options: ['1 Minute', '3 Minutes', '5 Minutes', '10 Minutes'],
              onChanged: (value) {
                setState(() {
                  selectedTime = value!;
                });
              },
            ),
            buildSettingOption(
              title: 'Increment',
              description:
              'The amount of time each player gets added to their clock every time they pass the move to the other player.',
              value: selectedIncrement,
              options: ['No Increment', '1 Second', '3 Seconds', '5 Seconds'],
              onChanged: (value) {
                setState(() {
                  selectedIncrement = value!;
                });
              },
            ),
            buildSettingOption(
              title: 'Delay',
              description:
              'On every move there is a certain delay (free time) that passes before the clock starts counting down.',
              value: selectedDelay,
              options: ['No Delay', '1 Second', '2 Seconds', '5 Seconds'],
              onChanged: (value) {
                setState(() {
                  selectedDelay = value!;
                });
              },
            ),
            buildSettingOption(
              title: 'Time Bars',
              description:
              'Colored bars at the bottom / top of the screen that visually show how much time is left. You can disable them if they annoy you.',
              value: selectedTimeBars,
              options: ['Visible', 'Invisible'],
              onChanged: (value) {
                setState(() {
                  selectedTimeBars = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingOption({
    required String title,
    required String description,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(description),
        SizedBox(height: 8),
        DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged,
        ),
        Divider(),
      ],
    );
  }
}
