
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



sealed class TimerState extends Equatable {
  final int duration;

  const TimerState(this.duration);

  @override
  List<Object?> get props => [duration];
}

final class TimerInitial extends TimerState {
  const TimerInitial(super.duration);

  @override
  String toString() {
    return 'TimerInitial{ duration: $duration}';
  }
}

final class TimerRunPause extends TimerState {
  TimerRunPause(super.duration);

  @override
  String toString() {
    return 'TimerRunPause{ duration: $duration}';
  }
}

final class TimerRunInProgress extends TimerState {
  TimerRunInProgress(super.duration);

  @override
  String toString() {
    return 'TimerRunInProgress{ duration: $duration}';
  }
}

final class TimerRunComplete extends TimerState {
  TimerRunComplete(): super(0);
}
