import 'package:go_clock/features/setings/data/repository_impl.dart';
import 'package:go_clock/features/setings/domain/repository.dart';
import 'package:go_clock/features/setings/presentation/bloc/settings_bloc.dart';

import '../../../core/di/init_module.dart';
import '../../timer_view/presentation/bloc/timer_bloc.dart';
import '../../timer_view/ticker.dart';

void initTimerModule() {
  getIt.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl()..init());

  getIt.registerFactory(() => SettingsBloc(getIt()));
  getIt.registerFactory(() => Ticker());
  getIt.registerFactory(() => TimerBloc(repository: getIt(), blackTicker: getIt(), whiteTicker: getIt()));
}
