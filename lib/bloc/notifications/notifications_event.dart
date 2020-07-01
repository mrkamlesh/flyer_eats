import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
}

class GetNotification extends NotificationsEvent {
  final String token;

  GetNotification(this.token);

  @override
  List<Object> get props => [token];
}
