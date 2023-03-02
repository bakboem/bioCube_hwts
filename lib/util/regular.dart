/*
 * Project Name:  [HWST] - hwst
 * File: /Users/bakbeom/work/hwst/lib/util/regular.dart
 * Created Date: 2021-08-10 09:40:00
 * Last Modified: 2023-03-02 19:15:36
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BIOCUBE ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

class RegExpUtil {
  static RegExp matchNumber = RegExp(r'[^\s\w]');
  static RegExp matchTwoNumber = RegExp(r'[0-9]{2}');
  static RegExp matchSpace = RegExp(r'\s+');
  static RegExp matchAllSpace = RegExp(r"\s+\b|\b\s");
  static RegExp matchMoreSpace = RegExp(r'^[\s*\S]');
  static RegExp matchSingleSpace = RegExp(r'^[\s\w]');
  static RegExp matchEnglishLetters = RegExp(r'^[a~z][A~Z]');
  static RegExp matchEnglishLettersAndNumber = RegExp(r'[a-zA-Z0-9]+');
  static RegExp matchBrackets = RegExp(r'(\(+|)+\)');
  static RegExp matchLeftBrackets = RegExp(r'(\(+)');
  static RegExp matchRightBrackets = RegExp(r'(\)+)');
  static RegExp matchKr = RegExp(r'[\uAC00-\uD7AF]+');
  static RegExp matchEmail = RegExp(r"^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$");
  static isMatch(String str, RegExp regExp) => regExp.hasMatch(str);

  static matchFirst(String str, RegExp regExp) => regExp.firstMatch(str)?.input;

  static String cutStr(String string, int start, int end) {
    return string.substring(start, end);
  }

  static String removeBrackets(String str) {
    if (isMatch(str, matchBrackets)) {
      int start = str.lastIndexOf(matchLeftBrackets) + 1;
      int end = str.lastIndexOf(matchRightBrackets);
      return cutStr(str, start, end);
    } else {
      return str;
    }
  }

  static String removeSpace(String str) {
    return str.replaceAll(' ', '');
  }
}
