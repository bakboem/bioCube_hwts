/*
 * Project Name:  [BIOCUBE] - HWST
 * File: /Users/bakbeom/work/hwst/lib/enums/language_type.dart
 * Created Date: 2023-01-27 12:28:04
 * Last Modified: 2023-02-22 22:44:50
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';

enum LanguageType {
  KR,
  CN,
  JP,
  TW,
  US,
  DE,
  FR,
  IT,
  ES,
  IN,
  KZ,
  PH,
  VN,
  ID,
  MN,
  MY,
}

extension LanguageTypeExtension on LanguageType {
  String get code {
    switch (this) {
      case LanguageType.KR:
        return 'ko';
      case LanguageType.CN:
        return 'zh';
      case LanguageType.JP:
        return 'ja';
      case LanguageType.TW:
        return 'zh';
      case LanguageType.US:
        return 'en';
      case LanguageType.DE:
        return 'de';
      case LanguageType.FR:
        return 'fr';
      case LanguageType.IT:
        return 'it';
      case LanguageType.ES:
        return 'es';
      case LanguageType.IN:
        return 'ta';
      case LanguageType.KZ:
        return 'kk';
      case LanguageType.PH:
        return 'en';
      case LanguageType.VN:
        return 'vi';
      case LanguageType.ID:
        return 'id';
      case LanguageType.MN:
        return 'mn';
      case LanguageType.MY:
        return 'ms';
    }
  }

  String get localText {
    switch (this) {
      case LanguageType.KR:
        return '한국어';
      case LanguageType.CN:
        return '中文简体';
      case LanguageType.JP:
        return '日本語';
      case LanguageType.TW:
        return '中文繁体';
      case LanguageType.US:
        return 'English';
      case LanguageType.DE:
        return 'Deutsch';
      case LanguageType.FR:
        return 'Français';
      case LanguageType.IT:
        return 'italiano';
      case LanguageType.ES:
        return 'Español';
      case LanguageType.IN:
        return 'भारतीय भाषा';
      case LanguageType.KZ:
        return 'Қазақ тілі';
      case LanguageType.PH:
        return 'Filipino';
      case LanguageType.VN:
        return 'Tiếng Việt';
      case LanguageType.ID:
        return 'bahasa Indonesia';
      case LanguageType.MN:
        return 'Монгол хэл';
      case LanguageType.MY:
        return 'malaysian';
    }
  }

  String get iconPath {
    switch (this) {
      default:
        return 'assets/country/${this.name.trim().toLowerCase()}.png';
    }
  }

  Locale get locale {
    switch (this) {
      default:
        return Locale(this.code, this.name);
    }
  }
}
