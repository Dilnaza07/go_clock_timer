part of 'timer_bloc.dart';

//Timer bloc имеет следующие состояния:

//TimerInitial - готов начать обратный отсчет с указанной продолжительности
//TimerRunInProgress - активный обратный отсчет от указанной продолжительности
//TimerRunPause - приостановлено на некотором оставшемся времени
//TimerRunComplete - завершено с оставшейся продолжительностью 0.

//Каждое из этих состояний будет иметь последствия для пользовательского интерфейса и действий, которые пользователь может выполнять. Например:
//
// если состояние равно , TimerInitialпользователь сможет запустить таймер.
// если состояние равно , TimerRunInProgressпользователь сможет приостановить и сбросить таймер, а также увидеть оставшуюся продолжительность.
// если состояние равно , TimerRunPauseпользователь сможет возобновить таймер и сбросить его.
// если состояние равно , TimerRunCompleteпользователь сможет сбросить таймер.

class TimerState extends Equatable {
  final int whiteDuration;
  final int blackDuration;
  final GameState gamestate;
  static int blackCount = 0;
  static int whiteCount = 0;
  static bool isBlackFirst = false;

  const TimerState(this.whiteDuration, this.blackDuration, this.gamestate);

  TimerState copyWith({
    int? whiteDuration,
    int? blackDuration,
    GameState? gamestate,
  }) {
    return TimerState(
      whiteDuration ?? this.whiteDuration,
      blackDuration ?? this.blackDuration,
      gamestate ?? this.gamestate,
    );
  }

  @override
  List<Object?> get props => [blackDuration, whiteDuration, gamestate];
}
