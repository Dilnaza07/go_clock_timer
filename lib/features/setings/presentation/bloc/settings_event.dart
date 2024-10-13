

part of 'settings_bloc.dart';





abstract class SettingsEvent extends Equatable{



  @override
  List<Object?> get props => throw UnimplementedError();

}

class SettingsDataSaved extends SettingsEvent {

}

class LoadSettingsEvent extends SettingsEvent {}

