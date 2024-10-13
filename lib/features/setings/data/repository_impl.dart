import 'package:go_clock/features/setings/domain/repository.dart';
import 'package:go_clock/features/setings/models/timer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const timeKey = "time";
const incrementKey = "increment";
const periodsKey = "periods";

class SettingsRepositoryImpl implements SettingsRepository {
  SharedPreferences? prefs;

  TimerModel? _model;

  void init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void saveTimerSettings(TimerModel model) async {
    _model = model;

    await prefs?.setString(timeKey, model.time);
    await prefs?.setString(incrementKey, model.increment);
    await prefs?.setString(periodsKey, model.periods);
  }

  void getTimerSettings() async {
    final String time = prefs?.getString(timeKey) ?? "120";
    final String increment = prefs?.getString(incrementKey) ?? "30";
    final String periods = prefs?.getString(periodsKey) ?? '3';

    TimerModel(time: time, increment: increment, periods: periods);
  }
}
