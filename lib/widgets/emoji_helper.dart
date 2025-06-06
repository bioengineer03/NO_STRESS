import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

class EmojiHelper {
  static final parser = EmojiParser();

  /// Restituisce un widget Text con emoji in base allo score
  static Widget getEmojiForStressScore(int score) {
    String emoji;
    if (score < 25) {
      emoji = parser.get('smile').code;  // 😀
    } else if (score >= 25 && score <= 75) {
      emoji = parser.get('neutral_face').code;  // 😐
    } else {
      emoji = parser.get('worried').code;  // 😟
    }

    return Text(
      emoji,
      style: TextStyle(fontSize: 80),
    );
  }
}