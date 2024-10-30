class TimerModel {
  final int time;
  final int increment;
  final int periods;

  TimerModel({
    required this.time,
    required this.increment,
    required this.periods,
  });


  TimerModel copyWith({
    int? time,
    int? increment,
    int? periods,
  }) {
    return TimerModel(
      time: time ?? this.time,
      increment: increment ?? this.increment,
      periods: periods ?? this.periods,
    );
  }
}
