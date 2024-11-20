import 'package:flutter/cupertino.dart';
import 'package:go_clock/features/settings/data/database/models/timer_entity.dart';
import 'package:go_clock/features/settings/data/database/service/timer_db_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/repository.dart';
import '../models/timer_model.dart';

const timeKey = "time";
const incrementKey = "increment";
const periodsKey = "periods";

class SettingsRepositoryImpl implements SettingsRepository {
  SharedPreferences? prefs;
  TimerDbService _timerDbService;

  SettingsRepositoryImpl({required TimerDbService timerDbService})
      : _timerDbService = timerDbService;

  TimerModel? _model;

  void init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // @override
  // Future saveTimerSettings(TimerModel model) async {
  //   _model = model;
  //
  //   await prefs?.setInt(timeKey, model.time * 60);
  //   await prefs?.setInt(incrementKey, model.increment);
  //   await prefs?.setInt(periodsKey, model.periods);
  // }

  @override
  Future saveTimerSettings(TimerModel model) async {
    final entity =
        TimerEntity(time: model.time, increment: model.increment, periods: model.periods, id: 0);
    _model = model;

    await _timerDbService.insertTimer(entity);
  }

//   @override
//   Future<TimerModel> getTimerSettings() async {
//     final int time = prefs?.getInt(timeKey) ?? 1200;
//     final int increment = prefs?.getInt(incrementKey) ?? 30;
//     final int periods = prefs?.getInt(periodsKey) ?? 3;
//
//     debugPrint("time $time");
//     debugPrint("increment $increment");
//     debugPrint("periods $periods");
//
//     return TimerModel(id: 0, time: time, increment: increment, periods: periods);
//   }
// }

  @override
  Future<List<TimerModel>> getTimerSettings() async {
    return _timerDbService.getTimers().then((list) => list
        .map((e) => TimerModel(id: e.id, time: e.time, increment: e.increment, periods: e.periods))
        .toList());
  }
}
