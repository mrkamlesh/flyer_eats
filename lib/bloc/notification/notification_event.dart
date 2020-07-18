import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class UpdateMessage extends NotificationEvent {
  final Map<String, dynamic> message;

  UpdateMessage(this.message);

  @override
  List<Object> get props => [message];
}

class ResetMessage extends NotificationEvent {
  ResetMessage();

  @override
  List<Object> get props => [];
}
