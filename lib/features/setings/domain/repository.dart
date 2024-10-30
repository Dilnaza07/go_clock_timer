

import 'package:go_clock/features/setings/models/timer_model.dart';

abstract class SettingsRepository{


Future saveTimerSettings(TimerModel model);

Future<TimerModel> getTimerSettings();

}