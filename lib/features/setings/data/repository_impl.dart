import 'package:flutter/cupertino.dart';
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
  Future saveTimerSettings(TimerModel model) async {
    _model = model;



    await prefs?.setInt(timeKey, model.time * 60 );
    await prefs?.setInt(incrementKey, model.increment);
    await prefs?.setInt(periodsKey, model.periods);
  }

  @override
  Future<TimerModel> getTimerSettings() async {
    final int time = prefs?.getInt(timeKey) ?? 1200;
    final int increment = prefs?.getInt(incrementKey) ?? 30;
    final int periods = prefs?.getInt(periodsKey) ?? 3;

    debugPrint("time $time");
    debugPrint("increment $increment");
    debugPrint("periods $periods");

    return TimerModel(time: time, increment: increment, periods: periods);
  }
}
