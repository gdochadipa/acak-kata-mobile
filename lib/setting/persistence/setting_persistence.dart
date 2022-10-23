import 'package:acakkata/models/user_model.dart';

abstract class SettingsPersistence {
  Future<bool> getMusicOn();

  Future<bool> getMuted({required bool defaultValue});

  Future<bool> getSoundsOn();

  Future<String> getLanguage();

  Future<UserModel> getUserLogin();

  Future<bool> getIsLogin();

  Future<void> saveMusicOn(bool value);

  Future<void> saveMuted(bool value);

  Future<void> saveSoundsOn(bool value);

  Future<void> saveLanguage(String language);

  Future<void> saveUserLogin(UserModel userModel);

  Future<void> saveIsLogin(bool value);
}
