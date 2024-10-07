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
  // final Ticker _whiteTicker;

  static const int _duration = 5;
  static const int _boyomi = 3;
  static const int _boyomiCount = 3;

  StreamSubscription<int>? _blackTickerSubscription;
  StreamSubscription<int>? _whiteTickerSubscription;

  //TODO: установить начальное состояние
  TimerBloc({required Ticker blackTicker, required Ticker whiteTicker})
      : _blackticker = blackTicker,
        // _whiteTicker = whiteTicker,
        super(TimerState(
        whiteDuration: _duration,
        blackDuration: _duration,
        gamestate: GameState.initial,
        blackCount: 0,
        whiteCount: 0,
        isBlackFirst: false,
        isGameRunning: false,
        whiteByoyomiCount: 0,
        blackByoyomiCount: 0,
      )) {
//TODO: реализовать обработчики событий
    on<BlackTimerClick>(_onBlackTimerClick);
    on<WhiteTimerClick>(_onWhiteTimerClick);
    on<BlackTimerStarted>(_onBlackStarted);
    on<WhiteTimerStarted>(_onWhiteStarted);
    on<BlackTimerPaused>(_onBlackPaused);
    on<BlackTimerResumed>(_onBlackResumed);
    on<GameReset>(_onReset);
    on<_BlackTimerTicked>(_onBlackTicked);
    on<_WhiteTimerTicked>(_onWhiteTicked);
    on<GamePaused>(_onGamePaused);
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



  _onBlackTimerClick(BlackTimerClick event, Emitter<TimerState> emit) {
    if (state.gamestate == GameState.initial && state.blackCount == 0) {
      add(WhiteTimerStarted(whiteDuration: _duration, gameState: GameState.blackPaused));
      debugPrint(
          'BlackTimerStarted, blackCount: ${state.blackCount}, gamestate: ${state.gamestate}');
    } else if (state.gamestate == GameState.blackRunning && state.whiteCount == 0) {
      emit(state.copyWith(blackCount: state.blackCount + 1));
      add(WhiteTimerStarted(whiteDuration: _duration, gameState: GameState.blackPaused));

      debugPrint(
          'WhiteTimerStarted, blackCount: ${state.blackCount}, gamestate: ${state.gamestate}');
    } else if (state.gamestate == GameState.blackRunning && state.whiteCount > 0) {
      emit(state.copyWith(blackCount: state.blackCount + 1));
      add(BlackTimerPaused());

      debugPrint(
          'BlackTimerPaused, blackCount: ${state.blackCount}, gamestate: ${state.gamestate}');
    }
  }

  _onWhiteTimerClick(WhiteTimerClick event, Emitter<TimerState> emit) {
    if (state.gamestate == GameState.initial && state.whiteCount == 0) {
      add(BlackTimerStarted(blackDuration: _duration, gameState: GameState.blackRunning));
      debugPrint('WhiteTimerStarted, whiteCount: ${state.whiteCount} gamestate ${state.gamestate}');
    } else if (state.gamestate == GameState.blackPaused && state.blackCount == 0) {
      emit(state.copyWith(whiteCount: state.whiteCount + 1));
      add(BlackTimerStarted(blackDuration: _duration));

      debugPrint(
          'BlackTimerStarted, whiteCount: ${state.whiteCount}, gamestate: ${state.gamestate}');
    } else if (state.gamestate == GameState.blackPaused && state.blackCount > 0) {
      emit(state.copyWith(whiteCount: state.whiteCount + 1));
      add(BlackTimerResumed());

      debugPrint(
          'BlackTimerResumed, whiteCount: ${state.whiteCount}, gamestate: ${state.gamestate} ');
    }
  }

  void _onBlackStarted(BlackTimerStarted event, Emitter<TimerState> emit) {
    _blackTickerSubscription?.cancel();

    debugPrint('_onBlackStarted: gameState=${event.gameState}');
    emit(state.copyWith(gamestate: event.gameState));
    if(_whiteTickerSubscription?.isPaused == false){
      _whiteTickerSubscription?.pause();
    }
    _blackTickerSubscription = _blackticker
        .tick(ticks: event.blackDuration)
        .listen((duration) => add(_BlackTimerTicked(blackDuration: duration)));
    _blackTickerSubscription?.onDone(()=>debugPrint('_blackTickerSubscription.onDone'));
    _blackTickerSubscription?.onError((error)=>debugPrint('_blackTickerSubscription.onError $error'));
  //  _blackTickerSubscription?.onData((data)=>debugPrint('_blackTickerSubscription.onData $data'));
  }

  void _onWhiteStarted(WhiteTimerStarted event, Emitter<TimerState> emit) {
    _whiteTickerSubscription?.cancel();
    debugPrint('_onWhiteStarted: gameState=${event.gameState}');
    emit(state.copyWith(gamestate: event.gameState));
    if(_blackTickerSubscription?.isPaused == false){
      _blackTickerSubscription?.pause();
   }
    _whiteTickerSubscription = _blackticker
        .tick(ticks: event.whiteDuration)
        .listen((duration) => add(_WhiteTimerTicked(whiteDuration: duration)));
    _whiteTickerSubscription?.onDone(()=>debugPrint('_whiteTickerSubscription.onDone'));
    _whiteTickerSubscription?.onError((error)=>debugPrint('_whiteTickerSubscription.onError $error'));
  //  _whiteTickerSubscription?.onData((data)=>debugPrint('_whiteTickerSubscription.onData $data'));
  }

  void _onBlackPaused(BlackTimerPaused event, Emitter<TimerState> emit) {
    debugPrint('_onBlackPaused');
    if (state.gamestate == GameState.blackRunning) {
      debugPrint('inside if ');
      if(_blackTickerSubscription?.isPaused == false){
        _blackTickerSubscription?.pause();
      }

      _whiteTickerSubscription?.resume();
      emit(state.copyWith(gamestate: GameState.blackPaused));
    }
  }

  void _onBlackResumed(BlackTimerResumed event, Emitter<TimerState> emit) {
    debugPrint('_onBlackResumed  ${state.gamestate}');
    if (state.gamestate == GameState.blackPaused) {
      if(_whiteTickerSubscription?.isPaused == false){
        _whiteTickerSubscription?.pause();
      }

      _blackTickerSubscription?.resume();
      emit(state.copyWith(gamestate: GameState.blackRunning));
    }
  }

  void _onBlackTicked(_BlackTimerTicked event, Emitter<TimerState> emit) {
    debugPrint(
        '_onBlackTicked,state.blackDuration ${event.blackDuration}, gamestate: ${state
            .gamestate} ');

    if( event.blackDuration > 0){
      emit( state.copyWith(
          blackDuration: event.blackDuration,
          gamestate: GameState.blackRunning,
          isGameRunning: true));
    }else if(_boyomiCount > state.blackByoyomiCount) {
      emit(state.copyWith(blackDuration: _boyomi, blackByoyomiCount: state.blackByoyomiCount +1));
      add(BlackTimerStarted(blackDuration: _boyomi));
      debugPrint(
          'Началось доп время ЧЕРНЫХ, период: ${state.blackByoyomiCount} ');
    }else{

      emit( state.copyWith(blackDuration: 0, gamestate: GameState.blackTimeOver));
    }

  }

  void _onWhiteTicked(_WhiteTimerTicked event, Emitter<TimerState> emit) {
    debugPrint(
        '_onWhiteTicked,state.whiteDuration ${event.whiteDuration}, gamestate: ${state
            .gamestate} ');
    if( event.whiteDuration > 0){
      emit( state.copyWith(
          whiteDuration: event.whiteDuration,
          // gamestate: GameState.blackPaused,
          isGameRunning: true));
    }else if(_boyomiCount > state.whiteByoyomiCount) {
      emit(state.copyWith(whiteDuration: _boyomi, whiteByoyomiCount: state.whiteByoyomiCount +1));
      add(WhiteTimerStarted(whiteDuration: _boyomi, gameState: GameState.blackPaused));
      debugPrint(
          'Началось доп время БЕЛЫХ, период: ${state.whiteByoyomiCount} ');
    }else{

      emit( state.copyWith(whiteDuration: 0, gamestate: GameState.whiteTimeOver));
    }
  }

  void _onReset(GameReset event, Emitter<TimerState> emit) {
    debugPrint('_onReset');
    _blackTickerSubscription?.cancel();
    _whiteTickerSubscription?.cancel();
    emit(state.copyWith(
        blackCount: 0, whiteCount: 0, isBlackFirst: false, gamestate: GameState.initial, blackByoyomiCount: 0,whiteByoyomiCount: 0));

    emit(state.copyWith(
        blackDuration: _duration, whiteDuration: _duration, gamestate: GameState.initial));
  }

  void _onGamePaused(GamePaused event, Emitter<TimerState> emit) {
    debugPrint('_onGamePaused');
    if (state.isGameRunning == true && state.gamestate == GameState.blackRunning) {
      if(_blackTickerSubscription?.isPaused == false){
        _blackTickerSubscription?.pause();
      }
      emit(state.copyWith(isGameRunning: false));
      debugPrint('_blackTickerSubscription?.pause();');
    } else if (state.isGameRunning == true && state.gamestate == GameState.blackPaused) {
      if(_whiteTickerSubscription?.isPaused == false){
        _whiteTickerSubscription?.pause();
      }
      emit(state.copyWith(isGameRunning: false));
      debugPrint('_whiteTickerSubscription?.pause();');
    } else if (state.isGameRunning == false && state.gamestate == GameState.blackRunning) {
      if(_blackTickerSubscription?.isPaused==true){
        _blackTickerSubscription?.resume();
        emit(state.copyWith(isGameRunning: true));
        debugPrint('_blackTickerSubscription?.resume();');
      }

    } else if (state.isGameRunning == false && state.gamestate == GameState.blackPaused) {

      if(_whiteTickerSubscription?.isPaused==true){
        debugPrint('_whiteTickerSubscription?.resume();');
        emit(state.copyWith(isGameRunning: true));
        _whiteTickerSubscription?.resume();
      }

    }
  }
}
