part of 'timer_bloc.dart';

//Нам TimerBlocнеобходимо знать, как обрабатывать следующие события:
//
// TimerStarted: информирует TimerBloc о необходимости запуска таймера.
// TimerPaused: информирует TimerBloc о том, что таймер следует приостановить.
// TimerResumed: информирует TimerBloc о том, что таймер следует возобновить.
// TimerReset: информирует TimerBloc о том, что таймер следует сбросить в исходное состояние.
// _TimerTicked: информирует TimerBloc о том, что произошел тик и что ему необходимо обновить свое состояние соответствующим образом.

sealed class TimerEvent {
  const TimerEvent();
}

final class TimerStarted extends TimerEvent {
  const TimerStarted({required this.duration});

  final int duration;
}

final class TimerPaused extends TimerEvent {
  const TimerPaused();
}

final class TimerResumed extends TimerEvent {
  const TimerResumed();
}

final class TimerReset extends TimerEvent {
  const TimerReset();
}

final class _TimerTicked extends TimerEvent {
  const _TimerTicked({required this.duration});

  final int duration;
}
