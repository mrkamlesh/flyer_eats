class Bank {
  final String id;
  final String text;

  Bank({this.id, this.text});

  factory Bank.fromJson(Map<String, dynamic> parsedJson) {
    return Bank(id: parsedJson['id'], text: parsedJson['text']);
  }
}
