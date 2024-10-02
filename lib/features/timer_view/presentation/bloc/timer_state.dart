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
  final int whiteByoyomiCount; // Количество использованных байоми периодов для белых
  final int blackByoyomiCount; // Количество использованных байоми периодов для черных
  final GameState gamestate;
  final int blackCount;

  final int whiteCount;

  final bool isBlackFirst;
  final bool isGameRunning;

  const TimerState({
    required this.whiteDuration,
    required this.blackDuration,
    required this.whiteByoyomiCount,
    required this.blackByoyomiCount,
    required this.gamestate,
    required this.blackCount,
    required this.whiteCount,
    required this.isBlackFirst,
    required this.isGameRunning,
  });

  TimerState copyWith({
    int? whiteDuration,
    int? blackDuration,
    int? blackByoyomiCount,
    int? whiteByoyomiCount,
    int? blackCount,
    int? whiteCount,
    bool? isBlackFirst,
    bool? isGameRunning,
    GameState? gamestate,
  }) {
    return TimerState(
      whiteDuration: whiteDuration ?? this.whiteDuration,
      blackDuration: blackDuration ?? this.blackDuration,
      whiteByoyomiCount: whiteByoyomiCount ?? this.whiteByoyomiCount,
      blackByoyomiCount: blackByoyomiCount ?? this.blackByoyomiCount,
      blackCount: blackCount ?? this.blackCount,
      whiteCount: whiteCount ?? this.whiteCount,
      isBlackFirst: isBlackFirst ?? this.isBlackFirst,
      isGameRunning: isGameRunning ?? this.isGameRunning,
      gamestate: gamestate ?? this.gamestate,
    );
  }

  @override
  List<Object?> get props => [
        blackDuration,
        whiteDuration,
        gamestate,
        isGameRunning,
        isBlackFirst,
        blackCount,
        whiteCount,
        blackByoyomiCount,
        whiteByoyomiCount,
      ];
}
