class ScratchCard {
  final String cardId;
  final double amount;
  final bool isScratched;

  ScratchCard({this.cardId, this.amount, this.isScratched});

  factory ScratchCard.fromJson(Map<String, dynamic> parsedJson) {
    return ScratchCard(cardId: parsedJson['card_id'], amount: double.parse(parsedJson['offer_amount'].toString()));
  }

  factory ScratchCard.fromListJson(Map<String, dynamic> parsedJson) {
    return ScratchCard(
        isScratched: parsedJson['is_scratched'],
        cardId: parsedJson['cardInfo']['card_id'],
        amount: double.parse(parsedJson['cardInfo']['offer_amount'].toString()));
  }

  ScratchCard copyWith({String cardId, double amount, bool isScratched}) {
    return ScratchCard(
        amount: amount ?? this.amount, cardId: cardId ?? this.cardId, isScratched: isScratched ?? this.isScratched);
  }
}
