class TimerModel {
  final int time;
  final int increment;
  final int periods;
  final int? id;

  TimerModel({
    required this.time,
     this.id,
    required this.increment,
    required this.periods,
  });


  TimerModel copyWith({
    int? id,
    int? time,
    int? increment,
    int? periods,
  }) {
    return TimerModel(
      id: id?? this.id,
      time: time ?? this.time,
      increment: increment ?? this.increment,
      periods: periods ?? this.periods,
    );
  }
}
