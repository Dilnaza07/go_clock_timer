

import 'package:get_it/get_it.dart';

import '../../features/setings/di/timer_module.dart';

final getIt = GetIt.instance;

void initMainModule() {
  initTimerModule();
}
