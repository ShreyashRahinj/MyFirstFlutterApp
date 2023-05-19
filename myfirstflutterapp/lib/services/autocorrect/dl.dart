import 'dart:math';
import 'package:string_validator/string_validator.dart';

class DL {
  int optimalStringAlignmentDistance(String s1, String s2) {
    var dp = List.generate(
        s1.length + 1, (i) => List.filled(s2.length + 1, 0, growable: false),
        growable: false);

    for (int i = 0; i <= s1.length; i++) {
      dp[i][0] = i;
    }

    for (int j = 0; j <= s2.length; j++) {
      dp[0][j] = j;
    }

    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 + min(min(dp[i - 1][j], dp[i][j - 1]), dp[i - 1][j - 1]);
        }
      }
    }

    return dp[s1.length][s2.length];
  }

  String nearestWord(String actualWord, List<String> data) {
    int diff = 1000;
    String tbReplace = actualWord;
    for (String word in data) {
      if (optimalStringAlignmentDistance(word, actualWord) < diff &&
          word.length == actualWord.length) {
        diff = optimalStringAlignmentDistance(word, actualWord);
        tbReplace = word;
      }
    }
    return tbReplace;
  }

  String autocorrectParagraph(List<String> paragraph, List<String> data) {
    String correctedText = "";
    for (int i = 0; i < paragraph.length; i++) {
      if (isLowercase(paragraph[i][0])) {
        correctedText += nearestWord(paragraph[i], data) + " ";
      } else {
        correctedText += paragraph[i] + " ";
      }
    }
    return correctedText;
  }
}
