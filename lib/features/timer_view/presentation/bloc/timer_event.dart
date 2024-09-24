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

final class BlackTimerStarted extends TimerEvent {
  const BlackTimerStarted({required this.blackDuration, this.gameState = GameState.blackRunning});

  final int blackDuration;
  final GameState gameState;
}

final class WhiteTimerStarted extends TimerEvent {
  const WhiteTimerStarted({required this.whiteDuration,this.gameState = GameState.blackPaused});
  final int whiteDuration;
  final GameState gameState;
}

final class BlackTimerPaused extends TimerEvent {
  const BlackTimerPaused();
}

final class WhiteTimerPaused extends TimerEvent {
  const WhiteTimerPaused();
}

final class GamePaused extends TimerEvent {
  const GamePaused();
}

final class GameResumed extends TimerEvent {
  const GameResumed();
}

final class BlackTimerResumed extends TimerEvent {
  const BlackTimerResumed();
}

final class WhiteTimerResumed extends TimerEvent {
  const WhiteTimerResumed();
}

final class GameReset extends TimerEvent { //сбросить оба таймера до начального состояния
  const GameReset();

}

final class _BlackTimerTicked extends TimerEvent {
  const _BlackTimerTicked({required this.blackDuration});

  final int blackDuration;
}

final class _WhiteTimerTicked extends TimerEvent {
  const _WhiteTimerTicked({required this.whiteDuration});

  final int whiteDuration;
}