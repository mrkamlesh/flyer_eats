import 'package:flyereats/model/notification.dart';

class NotificationsState {
  final List<NotificationItem> listNotification;
  final bool isLoading;
  final bool hasReachedMax;
  final int page;

  NotificationsState({this.page, this.isLoading, this.hasReachedMax, this.listNotification});
}

