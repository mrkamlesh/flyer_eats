import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginPhoneEvent extends Equatable {
  const LoginPhoneEvent();
}

class CheckPhoneExist extends LoginPhoneEvent {
  final String contactPhone;

  const CheckPhoneExist(this.contactPhone);

  @override
  List<Object> get props => [contactPhone];
}
