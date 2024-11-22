part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SettingsDataSaved extends SettingsEvent {}

class SettingsGameStarted extends SettingsEvent {}

class LoadSettingsEvent extends SettingsEvent {}

class SettingsPresetClickEvent extends SettingsEvent {
  final TimerModel timerModel;

  SettingsPresetClickEvent({required this.timerModel});

  @override
  List<Object?> get props => [
        timerModel,
      ];
}

class DeleteSettingsPresetEvent extends SettingsEvent {

  final int? id;
  final bool? isDefault;

  DeleteSettingsPresetEvent(this.id, this.isDefault);
}
