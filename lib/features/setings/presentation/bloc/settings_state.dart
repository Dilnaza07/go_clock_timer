part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final int duration;
  final int boyomi;
  final int period;
  final SettingsStateEnum settingsState;

  const SettingsState({required this.duration, required this.boyomi, required this.period, required this.settingsState});

  SettingsState copyWith({required int? duration, required int? boyomi, required int? period, SettingsStateEnum? settingsState}) {
    return SettingsState(duration: duration ?? this.duration, boyomi: boyomi?? this.boyomi, period: period?? this.period, settingsState: settingsState?? this.settingsState);
  }

  @override
  List<Object?> get props => [duration, boyomi, period,settingsState];
}
