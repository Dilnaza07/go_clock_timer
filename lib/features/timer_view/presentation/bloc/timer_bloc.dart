import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:go_clock/features/timer_view/models/game_state.dart';
import 'package:flutter/material.dart';
import '../../../settings/domain/repository.dart';
import '../../../settings/models/timer_model.dart';
import '../../ticker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'timer_state.dart';

part 'timer_event.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final SettingsRepository repository;
  final Ticker _blackticker;

  final player = AudioPlayer();




  StreamSubscription<int>? _blackTickerSubscription;
  StreamSubscription<int>? _whiteTickerSubscription;

  //TODO: установить начальное состояние
  TimerBloc({required this.repository, required Ticker blackTicker, required Ticker whiteTicker, required TimerModel timerModel})
      : _blackticker = blackTicker,
        // _whiteTicker = whiteTicker,
        super(TimerState(
          whiteDuration: 0,
          blackDuration: 0,
          gamestate: GameState.initial,
          blackCount: 0,
          whiteCount: 0,
          isBlackFirst: false,
          isGameRunning: false,
          whiteByoyomiCount: 0,
          blackByoyomiCount: 0,
          duration: 0,
          boyomi: 0,
          period: 0, isBayomi: false,
        )) {
//TODO: реализовать обработчики событий
    on<TimerInitialLoad>(_onTimerInitialLoad);
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

    add(TimerInitialLoad(timerModel: timerModel));
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

  _onTimerInitialLoad(TimerInitialLoad event, Emitter<TimerState> emit) async {
    TimerModel model = event.timerModel;

    emit(state.copyWith(duration: model.time * 60 , boyomi: model.increment, period: model.periods,
      blackDuration: model.time * 60, whiteDuration: model.time * 60));
  }

  _onBlackTimerClick(BlackTimerClick event, Emitter<TimerState> emit) async{

   await playSound('sounds/button.mp3');
    if (state.gamestate == GameState.initial && state.blackCount == 0) {
      add(WhiteTimerStarted(whiteDuration: state.duration, gameState: GameState.blackPaused));
      debugPrint(
          'BlackTimerStarted, blackCount: ${state.blackCount}, gamestate: ${state.gamestate}');
    } else if (state.gamestate == GameState.blackRunning && state.whiteCount == 0) {
      emit(state.copyWith(blackCount: state.blackCount + 1));
      add(WhiteTimerStarted(whiteDuration: state.duration, gameState: GameState.blackPaused));

      debugPrint(
          'WhiteTimerStarted, blackCount: ${state.blackCount}, gamestate: ${state.gamestate}');
    } else if (state.gamestate == GameState.blackRunning && state.whiteCount > 0) {
      emit(state.copyWith(blackCount: state.blackCount + 1));
      add(BlackTimerPaused());

      debugPrint(
          'BlackTimerPaused, blackCount: ${state.blackCount}, gamestate: ${state.gamestate}');
    }
  }

  _onWhiteTimerClick(WhiteTimerClick event, Emitter<TimerState> emit) async{
   await playSound('sounds/button.mp3');
    if (state.gamestate == GameState.initial && state.whiteCount == 0) {
      add(BlackTimerStarted(blackDuration: state.duration, gameState: GameState.blackRunning));
      debugPrint('WhiteTimerStarted, whiteCount: ${state.whiteCount} gamestate ${state.gamestate}');
    } else if (state.gamestate == GameState.blackPaused && state.blackCount == 0) {
      emit(state.copyWith(whiteCount: state.whiteCount + 1));
      add(BlackTimerStarted(blackDuration: state.duration));

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
    if (_whiteTickerSubscription?.isPaused == false) {
      _whiteTickerSubscription?.pause();
    }
    _blackTickerSubscription = _blackticker
        .tick(ticks: event.blackDuration)
        .listen((duration) => add(_BlackTimerTicked(blackDuration: duration)));
    _blackTickerSubscription?.onDone(() => debugPrint('_blackTickerSubscription.onDone'));
    _blackTickerSubscription
        ?.onError((error) => debugPrint('_blackTickerSubscription.onError $error'));
    //  _blackTickerSubscription?.onData((data)=>debugPrint('_blackTickerSubscription.onData $data'));
  }

  void _onWhiteStarted(WhiteTimerStarted event, Emitter<TimerState> emit) {
    _whiteTickerSubscription?.cancel();
    debugPrint('_onWhiteStarted: gameState=${event.gameState}');
    emit(state.copyWith(gamestate: event.gameState));
    if (_blackTickerSubscription?.isPaused == false) {
      _blackTickerSubscription?.pause();
    }
    _whiteTickerSubscription = _blackticker
        .tick(ticks: event.whiteDuration)
        .listen((duration) => add(_WhiteTimerTicked(whiteDuration: duration)));
    _whiteTickerSubscription?.onDone(() => debugPrint('_whiteTickerSubscription.onDone'));
    _whiteTickerSubscription
        ?.onError((error) => debugPrint('_whiteTickerSubscription.onError $error'));
    //  _whiteTickerSubscription?.onData((data)=>debugPrint('_whiteTickerSubscription.onData $data'));
  }

  void _onBlackPaused(BlackTimerPaused event, Emitter<TimerState> emit) {
    debugPrint('_onBlackPaused');
    if (state.gamestate == GameState.blackRunning) {
      debugPrint('inside if ');
      if (_blackTickerSubscription?.isPaused == false) {
        _blackTickerSubscription?.pause();
      }

      _whiteTickerSubscription?.resume();
      emit(state.copyWith(gamestate: GameState.blackPaused));
    }
  }

  void _onBlackResumed(BlackTimerResumed event, Emitter<TimerState> emit) {
    debugPrint('_onBlackResumed  ${state.gamestate}');
    if (state.gamestate == GameState.blackPaused) {
      if (_whiteTickerSubscription?.isPaused == false) {
        _whiteTickerSubscription?.pause();
      }

      _blackTickerSubscription?.resume();
      emit(state.copyWith(gamestate: GameState.blackRunning));
    }
  }

  void _onBlackTicked(_BlackTimerTicked event, Emitter<TimerState> emit) async{
    debugPrint(
        '_onBlackTicked,state.blackDuration ${event.blackDuration}, gamestate: ${state.gamestate} ');

    if (event.blackDuration > 0) {
      if(event.blackDuration < 10 && state.isBayomi){
        playSound('sounds/timeout.mp3');
      }
      emit(state.copyWith(
          blackDuration: event.blackDuration,
          gamestate: GameState.blackRunning,
          isGameRunning: true));
    } else if (state.period > state.blackByoyomiCount) {

      print("boyomi black: #----> ${state.boyomi}");
      emit(state.copyWith(blackDuration: state.boyomi, blackByoyomiCount: state.blackByoyomiCount + 1, isBayomi: true));
      add(BlackTimerStarted(blackDuration: state.boyomi));
      debugPrint('Началось доп время ЧЕРНЫХ, период: ${state.blackByoyomiCount} ');
    } else {
      emit(state.copyWith(blackDuration: 0, gamestate: GameState.blackTimeOver));
    await  playSound('sounds/buzzer.mp3');
    }
  }

  void _onWhiteTicked(_WhiteTimerTicked event, Emitter<TimerState> emit) async {
    debugPrint(
        '_onWhiteTicked,state.whiteDuration ${event.whiteDuration}, gamestate: ${state.gamestate} ');
    if (event.whiteDuration > 0) {

      if(event.whiteDuration < 10 && state.isBayomi){
        playSound('sounds/timeout.mp3');
      }
      emit(state.copyWith(
          whiteDuration: event.whiteDuration,
          // gamestate: GameState.blackPaused,
          isGameRunning: true));
    } else if (state.period > state.whiteByoyomiCount) {

      print("boyomi white: #----> ${state.boyomi}");
      emit(state.copyWith(whiteDuration: state.boyomi, whiteByoyomiCount: state.whiteByoyomiCount + 1, isBayomi: true));
      add(WhiteTimerStarted(whiteDuration: state.boyomi, gameState: GameState.blackPaused));
      debugPrint('Началось доп время БЕЛЫХ, период: ${state.whiteByoyomiCount} ');
    } else {
      emit(state.copyWith(whiteDuration: 0, gamestate: GameState.whiteTimeOver));
     await playSound('sounds/buzzer.mp3');
    }
  }

  void _onReset(GameReset event, Emitter<TimerState> emit) {
    debugPrint('_onReset');
    _blackTickerSubscription?.cancel();
    _whiteTickerSubscription?.cancel();
    emit(state.copyWith(
        blackCount: 0,
        whiteCount: 0,
        isBlackFirst: false,
        gamestate: GameState.initial,
        blackByoyomiCount: 0,
        whiteByoyomiCount: 0));

    emit(state.copyWith(
        blackDuration: state.duration, whiteDuration: state.duration, gamestate: GameState.initial));
  }

  void _onGamePaused(GamePaused event, Emitter<TimerState> emit) {
    debugPrint('_onGamePaused');
    if (state.isGameRunning == true && state.gamestate == GameState.blackRunning) {
      if (_blackTickerSubscription?.isPaused == false) {
        _blackTickerSubscription?.pause();
      }
      emit(state.copyWith(isGameRunning: false));
      debugPrint('_blackTickerSubscription?.pause();');
    } else if (state.isGameRunning == true && state.gamestate == GameState.blackPaused) {
      if (_whiteTickerSubscription?.isPaused == false) {
        _whiteTickerSubscription?.pause();
      }
      emit(state.copyWith(isGameRunning: false));
      debugPrint('_whiteTickerSubscription?.pause();');
    } else if (state.isGameRunning == false && state.gamestate == GameState.blackRunning) {
      if (_blackTickerSubscription?.isPaused == true) {
        _blackTickerSubscription?.resume();
        emit(state.copyWith(isGameRunning: true));
        debugPrint('_blackTickerSubscription?.resume();');
      }
    } else if (state.isGameRunning == false && state.gamestate == GameState.blackPaused) {
      if (_whiteTickerSubscription?.isPaused == true) {
        debugPrint('_whiteTickerSubscription?.resume();');
        emit(state.copyWith(isGameRunning: true));
        _whiteTickerSubscription?.resume();
      }
    }
  }


  // Функция для воспроизведения звука
  Future<void> playSound(String assetPath) async {
    print('Играет звук!!!');
    return player.play(AssetSource(assetPath));

  }


}
