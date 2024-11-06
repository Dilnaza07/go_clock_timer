import 'package:flutter/material.dart';

class TimerSettingsPage extends StatefulWidget {
  @override
  _TimerSettingsPageState createState() => _TimerSettingsPageState();
}

class _TimerSettingsPageState extends State<TimerSettingsPage> {
  bool _isSameTime = true; // Переменная для отслеживания выбора одинакового времени
  String? _selectedPlayer1Minutes;
  String? _selectedPlayer1Seconds;
  String? _selectedPlayer2Minutes;
  String? _selectedPlayer2Seconds;

  List<String> _minutesOptions = [
    '30 секунд', '35 секунд', '40 секунд', '45 секунд', '50 секунд', '55 секунд',
    '1 минута', '2 минуты', '3 минуты', '4 минуты', '5 минут', '6 минут',
    '7 минут', '8 минут', '9 минут', '10 минут', '12 минут', '15 минут',
    '20 минут', '25 минут', '30 минут', '35 минут', '40 минут', '45 минут',
    '50 минут', '55 минут', '1 час', '2 часа', '3 часа', '4 часа'
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки Таймера'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Блок готовых сетов (пресетов)
                  Text(
                    'Блок Пресетов',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Выберите готовый сет:'),
                  ListTile(
                    title: Text('Блиц игра: 10 минут основное время, 3 по 30 секунд байоми'),
                    leading: Radio(value: 'blitz', groupValue: 'gameType', onChanged: (_) {}),
                  ),
                  ListTile(
                    title: Text('Стандарт: 20 минут основное время, 3 по 30 секунд байоми'),
                    leading: Radio(value: 'standard', groupValue: 'gameType', onChanged: (_) {}),
                  ),
                  SizedBox(height: 20),

                  // Кнопка выбора одинакового времени
                  Row(
                    children: [
                      Checkbox(
                        value: _isSameTime,
                        onChanged: (value) {
                          setState(() {
                            _isSameTime = value!;
                            // Если выбрано одинаковое время, сбрасываем поля для игрока 2
                            if (_isSameTime) {
                              _selectedPlayer2Minutes = _selectedPlayer1Minutes;
                              _selectedPlayer2Seconds = _selectedPlayer1Seconds;
                            }
                          });
                        },
                      ),
                      Text('Выбрать одинаковое время для обоих игроков'),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Блок времени игроков
                  Text(
                    'Блок Времени Игроков',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Основное время (Игрок 1):'),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          value: _selectedPlayer1Minutes,
                          hint: Text('Минуты'),
                          isExpanded: true,
                          items: _minutesOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedPlayer1Minutes = newValue;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButton<String>(
                          value: _selectedPlayer1Seconds,
                          hint: Text('Секунды'),
                          isExpanded: true,
                          items: _minutesOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedPlayer1Seconds = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Поля для ввода времени второго игрока
                  if (!_isSameTime) ...[
                    Text('Основное время (Игрок 2):'),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedPlayer2Minutes,
                            hint: Text('Минуты'),
                            isExpanded: true,
                            items: _minutesOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedPlayer2Minutes = newValue;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedPlayer2Seconds,
                            hint: Text('Секунды'),
                            isExpanded: true,
                            items: _minutesOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedPlayer2Seconds = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],

                  // Блок японского байоми
                  Text(
                    'Японское байоми:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Количество периодов',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Минуты',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Секунды',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Блок настроек звука
                  Text(
                    'Блок Настроек Звука',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SwitchListTile(
                    title: Text('Включить звук'),
                    value: true,
                    onChanged: (value) {},
                  ),
                  SwitchListTile(
                    title: Text('Включить звук при окончании времени'),
                    value: false,
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 10),
                  Text('Ползунок громкости:'),
                  Slider(
                    value: 0.5,
                    onChanged: (value) {},
                    min: 0,
                    max: 1,
                    divisions: 10,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Логика для тестирования звука
                    },
                    child: Text('Тест звука'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            // Кнопки внизу
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: ElevatedButton(
                    onPressed: () {
                      // Логика для создания нового пресета
                    },
                    child: Text('Создать пресет'),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: ElevatedButton(
                    onPressed: () {
                      // Логика для удаления пресета
                    },
                    child: Text('Удалить пресет'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Центрированная кнопка PLAY
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), backgroundColor: Colors.blue, // Цвет кнопки
                  elevation: 5,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'PLAY',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 16), // Отступ внизу
          ],
        ),
      ),
    );
  }
}
