

import 'package:go_clock/features/setings/models/timer_model.dart';

abstract class SettingsRepository{


void saveTimerSettings(TimerModel model);

void getTimerSettings();

}