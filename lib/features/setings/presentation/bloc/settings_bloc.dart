import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_clock/features/setings/domain/repository.dart';
import 'package:go_clock/features/setings/models/settings_state.dart';
import 'package:go_clock/features/setings/models/timer_model.dart';

part 'settings_state.dart';

part 'settings_event.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {

  SettingsBloc(this.repository)
      : super(SettingsState(
            duration: 0, boyomi: 0, period: 0, settingsState: SettingsStateEnum.initial)) {
    on<SettingsDataSaved>(_onSaveSettings);

  }

  final SettingsRepository repository;


  final TextEditingController timeController = TextEditingController();
  final TextEditingController incrementController = TextEditingController();
  final TextEditingController periodsController = TextEditingController();

  _onSaveSettings(SettingsDataSaved event, Emitter<SettingsState> emit) async {

    final time = int.tryParse(timeController.text)?? 60;
    final increment = int.tryParse(incrementController.text)?? 10;
    final periods = int.tryParse(periodsController.text)?? 3;
    final model = TimerModel(

        time: time,
        increment: increment,
        periods: periods);

     await repository.saveTimerSettings(model);

     emit(state.copyWith(settingsState: SettingsStateEnum.settingsSaved));
  }
}
