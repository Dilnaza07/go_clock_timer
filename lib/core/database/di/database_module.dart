


import 'package:go_clock/core/database/timer_database.dart';

import '../../di/init_module.dart';

void initDatabaseModule() {

  getIt.registerSingleton(TimerDatabase());
}