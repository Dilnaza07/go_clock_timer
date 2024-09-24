import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_clock/features/timer_view/models/game_state.dart';

import '../../ticker.dart';
import '../bloc/timer_bloc.dart';

class ClockPage extends StatelessWidget {
  const ClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    GameState;
    return BlocProvider(
      create: (context) => TimerBloc(blackTicker: Ticker(), whiteTicker: Ticker()),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Transform.rotate(
                  angle: 3.14,
                  child: Stack(children: [
                    TimerViewWhite(),
                  ]),
                ),
              ),
              Actions(),
              Expanded(
                flex: 3,
                child: Stack(children: [
                  TimerViewBlack(),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimerViewWhite extends StatelessWidget {
  const TimerViewWhite({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Material(
          color: Colors.grey,
          child: InkWell(
            onTap: () {
              if (TimerState.isBlackFirst == false) {
                if (state.gamestate == GameState.initial && TimerState.whiteCount == 0) {
                  context
                      .read<TimerBloc>()
                      .add(WhiteTimerStarted(whiteDuration: state.whiteDuration));

                }
                if (state.gamestate == GameState.blackPaused && TimerState.blackCount == 0) {
                  context
                      .read<TimerBloc>()
                      .add(BlackTimerStarted(blackDuration: state.blackDuration));
                  TimerState.whiteCount++;
                }
              }

              if (state.gamestate == GameState.blackPaused&& TimerState.blackCount > 0 ) {
                context.read<TimerBloc>().add(BlackTimerResumed());
                TimerState.whiteCount++;
              }
            },
            child: Column(children: [
              SizedBox(height: 20),
              Row(children: [
                SizedBox(width: 25),
                Text(
                  'Ход: 1',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                SizedBox(width: 80),
                Text(
                  '3x(00:30)',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ]),
              SizedBox(height: 80),
              Center(
                child: TimerTextWhite(),
              ),
              SizedBox(height: 80),
              Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    'Период: ',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 20,
                  ),
                  Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 20,
                  ),
                  Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }
}

class TimerViewBlack extends StatelessWidget {
  const TimerViewBlack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Material(
          color: Colors.grey,
          child: InkWell(
            onTap: () {
              if (TimerState.blackCount == 0 && TimerState.whiteCount == 0) {
                TimerState.isBlackFirst = true;

                if (state.gamestate == GameState.initial && TimerState.blackCount == 0) {
                  context
                      .read<TimerBloc>()
                      .add(BlackTimerStarted(blackDuration: state.blackDuration));

                }
                if (state.gamestate == GameState.blackRunning && TimerState.whiteCount == 0) {
                  context
                      .read<TimerBloc>()
                      .add(WhiteTimerStarted(whiteDuration: state.whiteDuration));
                  TimerState.blackCount++;
                }
              }

              if (state.gamestate == GameState.blackRunning && TimerState.whiteCount >0) {
                context.read<TimerBloc>().add(WhiteTimerResumed());
                TimerState.blackCount++;
              }
            },
            child: Column(children: [
              SizedBox(height: 20),
              Row(children: [
                SizedBox(width: 25),
                Text(
                  'Ход: 1',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                SizedBox(width: 80),
                Text(
                  '3x(00:30)',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ]),
              SizedBox(height: 80),
              Center(
                child: TimerTextBlack(),
              ),
              SizedBox(height: 80),
              Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    'Период: ',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 20,
                  ),
                  Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 20,
                  ),
                  Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }
}

class TimerTextBlack extends StatelessWidget {
  const TimerTextBlack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.blackDuration);
    final hoursStr = (((duration / 60) / 60) % 60).floor().toString().padLeft(2, '0');
    final minutesStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');

    return Text(
      '$hoursStr:$minutesStr:$secondsStr',
      style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}

class TimerTextWhite extends StatelessWidget {
  const TimerTextWhite({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.whiteDuration);
    final hoursStr = (((duration / 60) / 60) % 60).floor().toString().padLeft(2, '0');
    final minutesStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');

    return Text(
      '$hoursStr:$minutesStr:$secondsStr',
      style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
        builder: (context, state) {
          return Container(
            color: Colors.black,
            height: 120,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              FloatingActionButton(
                child: Icon(Icons.play_arrow),
                onPressed: () => context.read<TimerBloc>().add(BlackTimerStarted(
                    blackDuration: state.blackDuration, gameState: GameState.blackRunning)),
              ),
              FloatingActionButton(
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () => context
                    .read<TimerBloc>()
                    .add(WhiteTimerStarted(whiteDuration: state.whiteDuration)),
              ),

              FloatingActionButton(
                  child: Icon(Icons.pause),
                  onPressed: () {
                    context.read<TimerBloc>().add(const GamePaused());
                  }),
              FloatingActionButton(
                  child: Icon(Icons.lock_reset),
                  onPressed: () {
                    context.read<TimerBloc>().add(const GameResumed());
                  }),
              FloatingActionButton(
                  child: Icon(
                    Icons.lock_reset,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    context.read<TimerBloc>().add(const GameReset());
                  }),

              FloatingActionButton(
                child: Icon(Icons.play_arrow),
                onPressed: () => context.read<TimerBloc>().add(const BlackTimerResumed()),
              ),
              FloatingActionButton(
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () => context.read<TimerBloc>().add(const WhiteTimerResumed()),
              ),
              // FloatingActionButton(
              //   child: Icon(Icons.replay),
              //   onPressed: () => context.read<TimerBloc>().add(const TimerReset()),
              // ),
              // FloatingActionButton(
              //   child: Icon(
              //     Icons.replay,
              //     color: Colors.white,
              //   ),
              //   onPressed: () => context.read<TimerBloc>().add(const TimerReset()),
              // ),
            ]),
          );
        });
  }
}
