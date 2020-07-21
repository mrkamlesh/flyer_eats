class StatusOrder {
  final String status;
  final String dateCreated;
  final String time;

  StatusOrder({this.status, this.dateCreated, this.time});

  factory StatusOrder.fromJson(Map<String, dynamic> parsedJson) {
    return StatusOrder(status: parsedJson['status'], dateCreated: parsedJson['date_created'], time: parsedJson['time']);
  }

  factory StatusOrder.fromJson2(Map<String, dynamic> parsedJson) {
    return StatusOrder(
        status: parsedJson['status'], dateCreated: parsedJson['order_date'], time: parsedJson['order_time']);
  }

  String getSubStatus() {
    switch (this.status) {
      case "Order Placed":
        return "Waiting for the merchant to accept";
      case "Food Preparing":
        return "Order accepted and preparing your food";
      case "On the way":
        return "Started from restaurant";
      case "Delivered":
        return "Order delivered successfully";
      case "Cancelled":
        return "Order is cancelled";
      case "Accepted":
        return "Order accepted and getting ready";
      default:
        return "";
    }
  }

  bool isDelivered() {
    return status == "Delivered";
  }

  bool isCancelled() {
    return status == "Cancelled";
  }

  String getIconAssets() {
    switch (this.status) {
      case "Order Placed":
        return "assets/order placed icon.svg";
      case "Food Preparing":
        return "assets/food preparing icon.svg";
      case "On the way":
        return "assets/on the way icon.svg";
      case "Delivered":
        return "assets/delivered icon.svg";
      case "Cancelled":
        return "assets/cancelled icon.svg";
      case "Accepted":
        return "assets/pending icon.svg";
      default:
        return "assets/cancelled icon.svg";
    }
  }
}
