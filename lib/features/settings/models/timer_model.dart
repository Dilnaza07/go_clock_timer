class TimerModel {
  final int time;
  final int increment;
  final int periods;
  final int? id;
  final bool isDefault;

  TimerModel({
    required this.time,
     this.id,
    required this.increment,
    required this.periods,
    this.isDefault = false,
  });


  TimerModel copyWith({
    int? id,
    int? time,
    int? increment,
    int? periods,
    bool? isDefault,
  }) {
    return TimerModel(
      id: id?? this.id,
      time: time ?? this.time,
      increment: increment ?? this.increment,
      periods: periods ?? this.periods,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
