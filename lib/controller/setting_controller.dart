import 'package:acakkata/setting/persistence/setting_persistence.dart';
import 'package:flutter/foundation.dart';

class SettingsController {
  final SettingsPersistence _persistence;

  ValueNotifier<bool> muted = ValueNotifier(false);

  ValueNotifier<bool> soundsOn = ValueNotifier(false);

  ValueNotifier<bool> musicOn = ValueNotifier(false);

  ValueNotifier<String> language = ValueNotifier('id');

  ValueNotifier<double> percentScore = ValueNotifier(60);

  ValueNotifier<double> percentTime = ValueNotifier(40);

  SettingsController({required SettingsPersistence persistence})
      : _persistence = persistence;

  Future<void> loadStateFromPersistence() async {
    await Future.wait([
      _persistence
          .getMuted(defaultValue: kIsWeb)
          .then((value) => muted.value = value),
      _persistence.getSoundsOn().then((value) => soundsOn.value = value),
      _persistence.getMusicOn().then((value) => musicOn.value = value),
    ]);
  }

  void toggleMusicOn() {
    musicOn.value = !musicOn.value;
    _persistence.saveMusicOn(musicOn.value);
  }

  void toggleMuted() {
    muted.value = !muted.value;
    _persistence.saveMuted(muted.value);
  }

  void toggleSoundsOn() {
    soundsOn.value = !soundsOn.value;
    _persistence.saveSoundsOn(soundsOn.value);
  }

  void toggleLanguageChoice(String flag) {
    language.value = flag;
    _persistence.saveLanguage(language.value);
  }

  void saveCalculateOfflineScore(
      {required double percentScoreInp, required double percentTimeInp}) {
    percentScore.value = percentScoreInp;
    percentTime.value = percentTimeInp;
    _persistence.setCalculatePercentByScore(percentScore.value);
    _persistence.setCalculatePercentByTime(percentTime.value);
  }

  void getCalculateOfflineScore() async {
    percentScore.value = await _persistence.getCalculatePercentByScore();
    percentTime.value = await _persistence.getCalculatePercentByTime();
  }
}
