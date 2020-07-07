class ScratchCard {
  final String cardId;
  final double amount;

  ScratchCard({this.cardId, this.amount});

  factory ScratchCard.fromJson(Map<String, dynamic> parsedJson) {
    return ScratchCard(cardId: parsedJson['card_id'], amount: double.parse(parsedJson['offer_amount'].toString()));
  }
}
