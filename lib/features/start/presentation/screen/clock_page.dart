import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ticker.dart';
import '../bloc/timer_bloc.dart';

class ClockPage extends StatelessWidget {
  const ClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBloc(ticker: Ticker()),
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
                    Material(
                      color: Colors.grey,
                      child: InkWell(
                        onTap: () {},
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
                            child: TimerTextPlayer2(),
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
                    ),
                  ]),
                ),
              ),
              Actions(),
              Expanded(
                flex: 3,
                child: Stack(children: [
                  TimerViewPlayer1(),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimerViewPlayer1 extends StatelessWidget {
  const TimerViewPlayer1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Material(
          color: Colors.grey,
          child: InkWell(
            onTap: () => context.read<TimerBloc>().add(TimerStarted(duration: state.duration)),
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
                child: TimerText(),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...switch (state) {
                TimerInitial() => [
                    FloatingActionButton(
                      child: Icon(Icons.play_arrow),
                      onPressed: () =>
                          context.read<TimerBloc>().add(TimerStarted(duration: state.duration)),
                    ),
                  ],
                TimerRunInProgress() => [
                    FloatingActionButton(
                      child: Icon(Icons.pause),
                      onPressed: () => context.read<TimerBloc>().add(const TimerPaused()),
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.replay),
                      onPressed: () => context.read<TimerBloc>().add(const TimerReset()),
                    ),
                  ],
                TimerRunPause() => [
                    FloatingActionButton(
                      child: Icon(Icons.play_arrow),
                      onPressed: () => context.read<TimerBloc>().add(const TimerResumed()),
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.replay),
                      onPressed: () => context.read<TimerBloc>().add(const TimerReset()),
                    ),
                  ],
                TimerRunComplete() => [
                    FloatingActionButton(
                      child: Icon(Icons.replay),
                      onPressed: () => context.read<TimerBloc>().add(const TimerReset()),
                    ),
                  ]
              }

              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(
              //     Icons.settings,
              //     color: Colors.white,
              //     size: 80,
              //   ),
              // ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(
              //     Icons.pause_circle,
              //     color: Colors.white,
              //     size: 80,
              //   ),
              // ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(
              //     Icons.refresh,
              //     color: Colors.white,
              //     size: 80,
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final hoursStr = (((duration / 60) / 60) % 60).floor().toString().padLeft(2, '0');
    final minutesStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');

    return Text(
      '$hoursStr:$minutesStr:$secondsStr',
      style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}

class TimerTextPlayer2 extends StatelessWidget {
  const TimerTextPlayer2({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final hoursStr = (((duration / 60) / 60) % 60).floor().toString().padLeft(2, '0');
    final minutesStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');

    return Text(
      '$hoursStr:$minutesStr:$secondsStr',
      style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}
