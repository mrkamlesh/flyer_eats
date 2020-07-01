class NotificationItem {
  final String title;
  final String message;
  final String dateCreated;

  NotificationItem({this.title, this.message, this.dateCreated});

  factory NotificationItem.fromJson(Map<String, dynamic> parsedJson) {
    return NotificationItem(
        title: parsedJson['push_title'], message: parsedJson['push_message'], dateCreated: parsedJson['date_created']);
  }
}
