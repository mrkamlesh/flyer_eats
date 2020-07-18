import 'package:meta/meta.dart';

@immutable
abstract class NotificationState {
  final Map<String, dynamic> message;

  NotificationState({this.message});
}

class NotReceiveNotification extends NotificationState {}

class ReceiveOrderNotification extends NotificationState {
  ReceiveOrderNotification({Map<String, dynamic> message}) : super(message: message);
}

class ReceiveCampaignNotification extends NotificationState {
  ReceiveCampaignNotification({Map<String, dynamic> message}) : super(message: message);
}

