import 'dart:async';
import 'package:go_clock/features/timer_view/models/game_state.dart';
import 'package:flutter/material.dart';
import '../../ticker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'timer_state.dart';

part 'timer_event.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _blackticker;
  final Ticker _whiteTicker;

  // final GameState _gameState;

  static const int _duration = 60;

  StreamSubscription<int>? _blackTickerSubscription;
  StreamSubscription<int>? _whiteTickerSubscription;

  //TODO: установить начальное состояние
  TimerBloc({required Ticker blackTicker, required Ticker whiteTicker})
      : _blackticker = blackTicker,
        _whiteTicker = whiteTicker,
        super(TimerState(_duration, _duration, GameState.initial)) {
//TODO: реализовать обработчики событий
    on<BlackTimerStarted>(_onBlackStarted);
    on<WhiteTimerStarted>(_onWhiteStarted);
    on<BlackTimerPaused>(_onBlackPaused);
    on<WhiteTimerPaused>(_onWhitePaused);
    on<BlackTimerResumed>(_onBlackResumed);
    on<WhiteTimerResumed>(_onWhiteResumed);
    on<GameReset>(_onReset);
    on<_BlackTimerTicked>(_onBlackTicked);
    on<_WhiteTimerTicked>(_onWhiteTicked);
    on<GamePaused>(_onGamePaused);
    on<GameResumed>(_onGameResumed);
  }

  @override
  Future<void> close() {
    _blackTickerSubscription?.cancel();
    return super.close();
  }

  @override
  Future<void> closeW() {
    _whiteTickerSubscription?.cancel();
    return super.close();
  }

  void _onBlackStarted(BlackTimerStarted event, Emitter<TimerState> emit) {
    debugPrint('_onBlackStarted');
    emit(state.copyWith(blackDuration: event.blackDuration, gamestate: event.gameState));
    _blackTickerSubscription?.cancel();
    _whiteTickerSubscription?.pause();
    _blackTickerSubscription = _blackticker
        .tick(ticks: event.blackDuration)
        .listen((duration) => add(_BlackTimerTicked(blackDuration: duration)));
  }

  void _onWhiteStarted(WhiteTimerStarted event, Emitter<TimerState> emit) {
    debugPrint('_onWhiteStarted');
    emit(state.copyWith(blackDuration: event.whiteDuration, gamestate: event.gameState));
    _whiteTickerSubscription?.cancel();
    _blackTickerSubscription?.pause();
    _whiteTickerSubscription = _whiteTicker
        .tick(ticks: event.whiteDuration)
        .listen((duration) => add(_WhiteTimerTicked(whiteDuration: duration)));
  }

  void _onBlackPaused(BlackTimerPaused event, Emitter<TimerState> emit) {
    debugPrint('_onBlackPaused');
    if (state.gamestate == GameState.blackPaused) {
      _blackTickerSubscription?.pause();
      _whiteTickerSubscription?.resume();
      emit(state.copyWith(blackDuration: state.blackDuration));
    }
  }

  void _onWhitePaused(WhiteTimerPaused event, Emitter<TimerState> emit) {
    debugPrint('_onWhitePaused');
    if (state.gamestate == GameState.blackRunning) {
      _whiteTickerSubscription?.pause();
      _blackTickerSubscription?.resume();
      emit(state.copyWith(whiteDuration: state.whiteDuration));
    }
  }

  void _onBlackResumed(BlackTimerResumed event, Emitter<TimerState> emit) {
    debugPrint('_onBlackResumed');
    if (state.gamestate == GameState.blackPaused) {
      _whiteTickerSubscription?.pause();
      _blackTickerSubscription?.resume();

      emit(state.copyWith(whiteDuration: state.blackDuration, gamestate: GameState.blackRunning));
    }
  }

  void _onWhiteResumed(WhiteTimerResumed event, Emitter<TimerState> emit) {
    debugPrint('_onWhiteResumed');
    if (state.gamestate == GameState.blackRunning) {
      _blackTickerSubscription?.pause();
      _whiteTickerSubscription?.resume();

      emit(state.copyWith(whiteDuration: state.whiteDuration, gamestate: GameState.blackPaused));
    }
  }

  void _onBlackTicked(_BlackTimerTicked event, Emitter<TimerState> emit) {
    debugPrint(
        '_onBlackTicked,state.blackDuration ${event.blackDuration}, gamestate: ${state.gamestate} ');
    emit(
      event.blackDuration > 0
          ? state.copyWith(blackDuration: event.blackDuration, gamestate: GameState.blackRunning)
          : state.copyWith(blackDuration: 0, gamestate: GameState.blackTimeOver),
    );
  }

  void _onWhiteTicked(_WhiteTimerTicked event, Emitter<TimerState> emit) {
    debugPrint(
        '_onWhiteTicked,state.whiteDuration ${event.whiteDuration}, gamestate: ${state.gamestate} ');
    emit(
      event.whiteDuration > 0
          ? state.copyWith(whiteDuration: event.whiteDuration, gamestate: GameState.blackPaused)
          : state.copyWith(whiteDuration: 0, gamestate: GameState.whiteTimeOver),
    );
  }

  void _onReset(GameReset event, Emitter<TimerState> emit) {
    debugPrint('_onReset');
    _blackTickerSubscription?.cancel();
    _whiteTickerSubscription?.cancel();
    TimerState.blackCount = 0;
    TimerState.whiteCount = 0;
    TimerState.isBlackFirst = false;

    emit(state.copyWith(
        blackDuration: _duration, whiteDuration: _duration, gamestate: GameState.initial));
  }

  void _onGamePaused(GamePaused event, Emitter<TimerState> emit) {
    debugPrint('_onGamePaused');
    if (state.gamestate == GameState.blackRunning) {
      _blackTickerSubscription?.pause();
      debugPrint('_blackTickerSubscription?.pause();');
    }

    if (state.gamestate == GameState.blackPaused) {
      _whiteTickerSubscription?.pause();
      debugPrint('_whiteTickerSubscription?.pause();');
    }
  }

  void _onGameResumed(GameResumed event, Emitter<TimerState> emit) {
    debugPrint('_onGameResumed');

    if (state.gamestate == GameState.blackRunning) {
      _blackTickerSubscription?.resume();
      debugPrint('_blackTickerSubscription?.resume();');
    }

    if (state.gamestate == GameState.blackPaused) {
      debugPrint('_whiteTickerSubscription?.resume();');
      _whiteTickerSubscription?.resume();
    }
  }
}
