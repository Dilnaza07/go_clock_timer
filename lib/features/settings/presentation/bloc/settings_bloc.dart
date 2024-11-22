import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository.dart';
import '../../models/settings_state.dart';
import '../../models/timer_model.dart';

part 'settings_state.dart';

part 'settings_event.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this.repository)
      : super(SettingsState(
          duration: 0,
          boyomi: 0,
          period: 0,
          settingsState: SettingsStateEnum.initial,
          presets: [],
        )) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<SettingsGameStarted>(_onStartGame);
    on<SettingsDataSaved>(_onSaveSettingsPreset);
    on<SettingsPresetClickEvent>(_onSettingsPresetClick);
    on<DeleteSettingsPresetEvent>(_onDeleteSettingsPreset);
  }

  final SettingsRepository repository;

  final TextEditingController timeController = TextEditingController();
  final TextEditingController incrementController = TextEditingController();
  final TextEditingController periodsController = TextEditingController();


  // Дефолтные пресеты
  final List<TimerModel> defaultPresets = [
    TimerModel(time: 20, increment: 30, periods: 3, isDefault: true), // Standard Game
    TimerModel(time: 1, increment: 20, periods: 3, isDefault: true), // Blitz Game
  ];

  _onLoadSettings(LoadSettingsEvent event, Emitter<SettingsState> emit) async {

    // Загружаем пресеты из базы данных
    final timerModels = await repository.getTimerSettings();

    final presets = timerModels + defaultPresets;

      emit(state.copyWith(presets: presets));

  }

  _onStartGame(SettingsGameStarted event, Emitter<SettingsState> emit) async {
    final time = (int.tryParse(timeController.text) ?? 1);
    final increment = int.tryParse(incrementController.text) ?? 10;
    final periods = int.tryParse(periodsController.text) ?? 2;
    final model = TimerModel(time: time, increment: increment, periods: periods);

    emit(state.copyWith(settingsState: SettingsStateEnum.settingsSaved, timerModel: model));
  }

  _onSaveSettingsPreset(SettingsDataSaved event, Emitter<SettingsState> emit) async {
    final time = (int.tryParse(timeController.text) ?? 1);
    final increment = int.tryParse(incrementController.text) ?? 10;
    final periods = int.tryParse(periodsController.text) ?? 2;
    final model = TimerModel(time: time, increment: increment, periods: periods);

    await repository.saveTimerSettings(model);
    add(LoadSettingsEvent());
  }

  _onSettingsPresetClick(SettingsPresetClickEvent event, Emitter<SettingsState> emit) {
    timeController.text = event.timerModel.time.toString();
    incrementController.text = event.timerModel.increment.toString();
    periodsController.text = event.timerModel.periods.toString();
  }

  _onDeleteSettingsPreset(DeleteSettingsPresetEvent event, Emitter<SettingsState> emit) async{
    final int? id = event.id;
    final bool? isDefault = event.isDefault;

    if (id != null && isDefault != true) {
      await repository.deleteTimerModel(id);

      add(LoadSettingsEvent());
    }
  }
}
