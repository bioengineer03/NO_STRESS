class CardModel {
  final String content;
  bool isRevealed;
  bool isMatched;

  CardModel({
    required this.content,
    this.isRevealed = false,
    this.isMatched = false,
  });
}