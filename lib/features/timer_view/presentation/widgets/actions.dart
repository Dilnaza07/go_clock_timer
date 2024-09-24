import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_clock/features/timer_view/models/game_state.dart';

import '../bloc/timer_bloc.dart';

class Actions extends StatelessWidget {
  const Actions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (prev, state)=>prev.runtimeType != state.runtimeType,
    builder: (context, state) {
    return Container(
    color: Colors.black,
    height: 120,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
    ...switch (state.gamestate) {
    GameState.initial => [
    FloatingActionButton(
    child: Icon(Icons.play_arrow),
    onPressed: () =>
    context.read<TimerBloc>().add(BlackTimerStarted(blackDuration: state.blackDuration)),
    ),
    FloatingActionButton(
    child: Icon(Icons.play_arrow, color: Colors.white,),
    onPressed: () =>
    context.read<TimerBloc>().add(WhiteTimerStarted(whiteDuration: state.whiteDuration)),
    ),
    ],
    GameState.blackRunning => [
    FloatingActionButton(
    child: Icon(Icons.pause),
    onPressed: () => context.read<TimerBloc>().add(const BlackTimerPaused()),
    ),
    FloatingActionButton(
    child: Icon(Icons.play_arrow, color: Colors.white,),
    onPressed: () =>
    context.read<TimerBloc>().add(WhiteTimerStarted(whiteDuration: state.whiteDuration)),
    ),
    ],
    GameState.blackPaused => [
    FloatingActionButton(
    child: Icon(Icons.play_arrow),
    onPressed: () => context.read<TimerBloc>().add(const BlackTimerResumed()),
    ),
    FloatingActionButton(
    child: Icon(Icons.pause,color: Colors.white,),
    onPressed: () => context.read<TimerBloc>().add(const WhiteTimerPaused()),
    ),
    ],
    GameState.blackTimeOver => [
    FloatingActionButton(
    child: Icon(Icons.replay),
    onPressed: () => context.read<TimerBloc>().add(const GameReset()),
    ),
    ],
    GameState.whiteTimeOver => [
    FloatingActionButton(
    child: Icon(Icons.replay, color: Colors.white,),
    onPressed: () => context.read<TimerBloc>().add(const GameReset()),
    ),
    ],
    }],
    ),
    );
    }
    );
    }
  }


