


import '../models/timer_model.dart';

abstract class SettingsRepository{


Future saveTimerSettings(TimerModel model);

Future<List<TimerModel>> getTimerSettings();
Future deleteTimerModel(int id);

}