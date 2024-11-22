import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_clock/core/di/init_module.dart';
import 'package:go_clock/features/timer_view/presentation/screen/timer_page.dart';
import '../../models/settings_state.dart';
import '../../models/timer_model.dart';
import '../bloc/settings_bloc.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Настройки таймера')),
        backgroundColor: Colors.blueGrey[300],
      ),
      body: BlocProvider(
        create: (context) => getIt<SettingsBloc>()..add(LoadSettingsEvent()),
        child: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            final timerModel = state.timerModel;

            if (state.settingsState == SettingsStateEnum.settingsSaved && timerModel != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClockPage(
                          timerModel: timerModel,
                        )),
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

    return Stack(
      children: [
        // Задний фон
        Positioned.fill(
          child: Image.asset(
            'assets/bd/bd3.png',
            fit: BoxFit.cover,
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Expanded(
              child: Padding(
                // padding: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: ListView(children: [
                  Text(
                    'Блок Пресетов',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Выберите готовый пресет:'),
                  SizedBox(height: 10),
                  PresetsListWidget(bloc: bloc),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_validateFields(context, bloc)) {
                                  bloc.add(SettingsGameStarted());
                                }
                              },
                              child: Text(
                                'Старт',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                                backgroundColor: Colors.blueGrey[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: TextStyle(fontSize: 18),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (_validateFields(context, bloc)) {
                                      bloc.add(SettingsDataSaved());
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueGrey[200],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),),
                                  ),
                                  child: Text('Создать пресет'),
                                  // style: ElevatedButton.styleFrom(
                                  //   padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                                  //   backgroundColor: Colors.blueGrey[100],
                                  //   shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //   ),
                                  //   textStyle: TextStyle(fontSize: 18),
                                  // ),


                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            ),
          ]),
        ),
      ],
    );
  }
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
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
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


class PresetsListWidget extends StatelessWidget {
  const PresetsListWidget({
    super.key,
    required this.bloc,
  });

  final SettingsBloc bloc;

  @override
  Widget build(BuildContext context) {
    final presets = context.select((SettingsBloc bloc) => bloc.state.presets);
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: presets.length,
        itemBuilder: (BuildContext context, int index) {
          return PresetWidget(timerModel: presets[index]);
        },
      ),
    );
  }
}

class PresetWidget extends StatelessWidget {
  const PresetWidget({
    super.key,
    required this.timerModel,
  });

  final TimerModel timerModel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            context.read<SettingsBloc>().add(SettingsPresetClickEvent(timerModel: timerModel));
          },
          child: Row(
            children: [
              Text('${timerModel.time}min + ${timerModel.periods}x${timerModel.increment}s'),
              timerModel.isDefault
                  ? SizedBox()
                  : IconButton(
                onPressed: () {
                  context.read<SettingsBloc>().add(DeleteSettingsPresetEvent(timerModel.id, timerModel.isDefault));
                },
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey[200],
          ),
        );
      },
    );
  }
}
