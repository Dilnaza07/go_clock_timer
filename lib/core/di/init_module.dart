import 'package:get_it/get_it.dart';

import '../../features/settings/di/timer_module.dart';
import '../database/di/database_module.dart';

final getIt = GetIt.instance;

void initMainModule() {
  initDatabaseModule();
  initTimerModule();
}
