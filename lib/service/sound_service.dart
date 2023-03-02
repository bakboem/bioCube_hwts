/*
 * Project Name:  [TruePass]
 * File: /Users/bakbeom/work/truepass/lib/service/sound_service.dart
 * Created Date: 2023-01-29 12:31:55
 * Last Modified: 2023-01-29 18:07:15
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2023  BioCube ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class SoundService {
  factory SoundService() => _sharedInstance();
  static SoundService? _instance;
  SoundService._();
  static SoundService _sharedInstance() {
    _instance ??= SoundService._();
    return _instance!;
  }

  static Soundpool? pool;
  static int? soundId;
  static Future<void> init() async {
    pool = Soundpool.fromOptions();
    soundId = await rootBundle
        .load("assets/sound/sound-2.wav")
        .then((ByteData soundData) {
      return pool!.load(soundData);
    });
  }

  static Future<void> playSound() async {
    await pool!.play(soundId!);
  }

  static void dispose() {
    pool!.dispose();
  }
}
