import 'package:flutter/material.dart';
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
      ),
      body: BlocProvider(
        create: (context) => SettingsBloc(getIt()),
        child: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state.settingsState == SettingsStateEnum.settingsSaved) {
              // При сохранении данных можно перейти к экрану таймера
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: bloc.timeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Основное время (минуты)'),
          ),
          TextField(
            controller: bloc.incrementController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Доп время (секунды)'),
          ),
          TextField(
            controller: bloc.periodsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Количество периодов доп времени'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
             bloc.add(SettingsDataSaved());


            },
            child: Text('Начать игру'),
          ),
        ],
      ),
    );
  }
}
