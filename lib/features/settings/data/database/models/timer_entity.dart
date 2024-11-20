import 'package:go_clock/features/settings/data/database/service/timer_db_service.dart';

class TimerEntity {
  final int time;
  final int increment;
  final int periods;
  final int id;

  TimerEntity({
    required this.time,
    required this.increment,
    required this.periods,
    required this.id,
  });

  factory TimerEntity.fromJson(Map<String, dynamic> json) {
    return TimerEntity(
      id: json[TimerDbService.columnId],
      time: json[TimerDbService.columnTime],
      increment: json[TimerDbService.columnIncrement],
      periods: json[TimerDbService.columnPeriods],
    );
  }

  Map<String, dynamic> toJson() => {
  //  TimerDbService.columnId: id,
    TimerDbService.columnTime: time,
    TimerDbService.columnPeriods: periods,
    TimerDbService.columnIncrement: increment,
  };


  TimerEntity copyWith({
    int? id,
    int? time,
    int? increment,
    int? periods,
  }) {
    return TimerEntity(
      id: id ?? this.id,
      time: time ?? this.time,
      increment: increment ?? this.increment,
      periods: periods ?? this.periods,
    );
  }
}
