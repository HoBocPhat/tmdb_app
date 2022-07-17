part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();
  @override
  List<Object> get props => [];
}

class ChangeFingerprint extends SettingEvent {
  final bool value;
  const ChangeFingerprint(this.value);
}

class GetBiometric extends SettingEvent{

}