import 'package:go_clock/features/setings/data/repository_impl.dart';
import 'package:go_clock/features/setings/domain/repository.dart';
import 'package:go_clock/features/setings/presentation/bloc/settings_bloc.dart';

import '../../../core/di/init_module.dart';

void initTimerModule() {
  getIt.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl());

  getIt.registerFactory(() => SettingsBloc(getIt()));
}
