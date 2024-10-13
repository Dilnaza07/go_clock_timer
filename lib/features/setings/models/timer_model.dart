class TimerModel {
  final String time;
  final String increment;
  final String periods;

  TimerModel({
    required this.time,
    required this.increment,
    required this.periods,
  });


  TimerModel copyWith({
    String? time,
    String? increment,
    String? periods,
  }) {
    return TimerModel(
      time: time ?? this.time,
      increment: increment ?? this.increment,
      periods: periods ?? this.periods,
    );
  }
}
