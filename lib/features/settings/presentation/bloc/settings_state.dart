part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final int duration;
  final int boyomi;
  final int period;
  final TimerModel? timerModel;

  final SettingsStateEnum settingsState;

  const SettingsState(
      {required this.duration,
      required this.boyomi,
      required this.period,
      required this.settingsState,
      this.timerModel});

  SettingsState copyWith(
      {int? duration,
      int? boyomi,
      int? period,
      SettingsStateEnum? settingsState,
      TimerModel? timerModel}) {
    return SettingsState(
      duration: duration ?? this.duration,
      boyomi: boyomi ?? this.boyomi,
      period: period ?? this.period,
      settingsState: settingsState ?? this.settingsState,
      timerModel: timerModel ?? this.timerModel,
    );
  }

  @override
  List<Object?> get props => [
        duration,
        boyomi,
        period,
        settingsState,
        timerModel,
      ];
}
