import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_clock/features/setings/presentation/screen/set_page.dart';
import 'package:go_clock/features/timer_view/models/game_state.dart';

import '../../../../core/di/init_module.dart';
import '../../ticker.dart';
import '../bloc/timer_bloc.dart';

class ClockPage extends StatelessWidget {
  const ClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    GameState;
    return BlocProvider(
      create: (context) => getIt<TimerBloc>(),
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
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Transform.rotate(
            angle: 3.14,
            child: TimerViewWhite(),
          ),
        ),
        Actions(),
        Expanded(
          flex: 1,
          child: TimerViewBlack(),
        ),
      ],
    );
  }
}

class TimerViewWhite extends StatelessWidget {
  const TimerViewWhite({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
  //  final period = context.select((TimerBloc bloc) => bloc.state.);

    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        Color? fieldColor = Colors.grey;
        if( state.gamestate == GameState.blackPaused){
          fieldColor = Colors.purpleAccent; }
        // else if(state.isGameRunning==false && state.gamestate!= GameState.initial){
        //   fieldColor = Colors.yellow;}
        else if(state.gamestate == GameState.whiteTimeOver){
          fieldColor = Colors.red[800];
        }

        return Material(
        color: fieldColor,
          child: InkWell(
            onTap: () {
              context.read<TimerBloc>().add(WhiteTimerClick());
            },
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Row(children: [
                SizedBox(width: 25),
                Text(
                  'Ход: ${state.whiteCount}',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                SizedBox(width: 80),
              //  WhiteByoYomiText(),
              ]),
              // SizedBox(height: 80),
              Center(
                child: TimerTextWhite(),
              ),
              // SizedBox(height: 80),
              Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    'Период: ${state.whiteByoyomiCount}/${state.period}',
                    style: TextStyle(color: Colors.white, fontSize: 25),
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

// class WhiteByoYomiText extends StatelessWidget {
//   const WhiteByoYomiText({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     @override
//     final duration = context.select((TimerBloc bloc) => bloc.state.whiteDuration);
//     final period = context.select((TimerBloc bloc) => bloc.state.whiteByoyomiCount);
//     final minutesStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
//     final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
//
//     return Text(
//       '${period}x($minutesStr:$secondsStr)',
//       style: TextStyle(fontSize: 25, color: Colors.white),
//     );
//   }
// }


// class BlackByoYomiText extends StatelessWidget {
//   const BlackByoYomiText({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     @override
//     final duration = context.select((TimerBloc bloc) => bloc.state.blackDuration);
//     final period = context.select((TimerBloc bloc) => bloc.state.blackByoyomiCount);
//     final minutesStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
//     final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
//
//     return Text(
//       '${period}x($minutesStr:$secondsStr)',
//       style: TextStyle(fontSize: 25, color: Colors.white),
//     );
//   }
// }

class TimerViewBlack extends StatelessWidget {
  const TimerViewBlack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {

        Color? fieldColor = Colors.grey;
        if( state.gamestate == GameState.blackRunning){
          fieldColor = Colors.purpleAccent; }
        // else if(state.isGameRunning==false && state.gamestate!= GameState.initial){
        //   fieldColor = Colors.orange;}
        else if(state.gamestate == GameState.blackTimeOver){
          fieldColor = Colors.red;
        }
        return Material(
          color: fieldColor,
          child: InkWell(
            onTap: () {
              context.read<TimerBloc>().add(BlackTimerClick());
            },
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(children: [
                  SizedBox(width: 25),
                  Text(
                    'Ход: ${state.blackCount}',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  SizedBox(width: 80),
                 // BlackByoYomiText(),
                ]),
              ),
              // SizedBox(height: 80),
              Center(
                child: TimerTextBlack(),
              ),
              // SizedBox(height: 80),
              Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    'Период: ${state.blackByoyomiCount}/${state.period}',
                    style: TextStyle(color: Colors.white, fontSize: 25),
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
                  child: Icon(Icons.pause),
                  onPressed: () {
                    context.read<TimerBloc>().add(const GamePaused());
                  }),
              FloatingActionButton(
                  child: Icon(
                    Icons.refresh,
                  ),
                  onPressed: () {
                    context.read<TimerBloc>().add(const GameReset());
                  }),
              FloatingActionButton(
                  child: Icon(Icons.settings),
                  onPressed: () {
                    context.read<TimerBloc>().add(const GamePaused());

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),

                    );
                  }),
            ]),
          );
        });
  }
}
