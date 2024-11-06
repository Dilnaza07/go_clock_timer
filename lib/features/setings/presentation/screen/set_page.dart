import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_clock/core/di/init_module.dart';
import 'package:go_clock/features/setings/presentation/bloc/settings_bloc.dart';
import 'package:go_clock/features/timer_view/presentation/screen/clock_page.dart';
import '../../../timer_view/presentation/bloc/timer_bloc.dart';
import '../../models/settings_state.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки таймера'),
        backgroundColor: Colors.blueGrey[300],
      ),
      body: BlocProvider(
        create: (context) => SettingsBloc(getIt()),
        child: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state.settingsState == SettingsStateEnum.settingsSaved) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClockPage()),
              );
            }
          },
          child: _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SettingsBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Основное время"),
          _buildDescription("Введите основное время для каждого игрока"),
          _buildNumberInput(
            bloc.timeController,
            label: 'Время (минуты)',
            hint: 'Например, 30',
          ),
          SizedBox(height: 24),
          _buildSectionTitle("Японское байоми"),
          _buildDescription("Введите дополнительное время для каждого игрока"),
          _buildNumberInput(
            bloc.incrementController,
            label: 'Доп. время (секунды)',
            hint: 'Например, 60',
          ),
          SizedBox(height: 24),
          _buildSectionTitle("Периоды"),
          _buildDescription("Введите количество периодов байоми"),
          _buildNumberInput(
            bloc.periodsController,
            label: 'Кол-во периодов',
            hint: 'Например, 5',
          ),
          SizedBox(height: 36),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_validateFields(context, bloc)) {
                  bloc.add(SettingsDataSaved());
                }
              },
              child: Text('Старт', style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                backgroundColor: Colors.blueGrey[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDescription(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildNumberInput(
      TextEditingController controller, {
        required String label,
        String? hint,
      }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      inputFormatters:  [   FilteringTextInputFormatter.digitsOnly, // Только цифры
      ],
    );
  }

  bool _validateFields(BuildContext context, SettingsBloc bloc) {
    if (bloc.timeController.text.isEmpty ||
        bloc.incrementController.text.isEmpty ||
        bloc.periodsController.text.isEmpty) {
      _showErrorDialog(context, "Все поля должны быть заполнены.");
      return false;
    }
    if (int.tryParse(bloc.timeController.text) == null ||
        int.tryParse(bloc.incrementController.text) == null ||
        int.tryParse(bloc.periodsController.text) == null) {
      _showErrorDialog(context, "Пожалуйста, введите корректные числовые значения.");
      return false;
    }
    return true;
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ошибка"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("ОК"),
          ),
        ],
      ),
    );
  }
}
