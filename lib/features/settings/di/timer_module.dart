import 'package:go_clock/features/settings/data/database/service/timer_db_service.dart';

import '../../../core/di/init_module.dart';
import '../../timer_view/presentation/bloc/timer_bloc.dart';
import '../../timer_view/ticker.dart';
import '../data/settings_repository_impl.dart';
import '../domain/repository.dart';
import '../models/timer_model.dart';
import '../presentation/bloc/settings_bloc.dart';

void initTimerModule() {
  getIt.registerLazySingleton(() => TimerDbService(notesDatabase: getIt()));
  getIt.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(timerDbService: getIt())..init());

  getIt.registerFactory(() => SettingsBloc(getIt()));
  getIt.registerFactory(() => Ticker());
  getIt.registerFactoryParam((TimerModel param1, param2) => TimerBloc(
        repository: getIt(),
        blackTicker: getIt(),
        whiteTicker: getIt(),
        timerModel: param1,
      ));
}
