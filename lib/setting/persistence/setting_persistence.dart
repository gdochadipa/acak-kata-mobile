import 'package:acakkata/models/server_url.dart';
import 'package:acakkata/models/user_model.dart';

abstract class SettingsPersistence {
  Future<bool> getMusicOn();

  Future<bool> getMuted({required bool defaultValue});

  Future<bool> getSoundsOn();

  Future<String> getLanguage();

  Future<UserModel> getUserLogin();

  Future<bool> getIsLogin();

  Future<double> getCalculatePercentByScore();

  Future<double> getCalculatePercentByTime();

  Future<void> saveMusicOn(bool value);

  Future<void> saveMuted(bool value);

  Future<void> saveSoundsOn(bool value);

  Future<void> saveLanguage(String language);

  Future<void> saveUserLogin(UserModel userModel);

  Future<void> saveIsLogin(bool value);

  Future<void> setCalculatePercentByScore(double calculate);

  Future<void> setCalculatePercentByTime(double calculate);

  Future<void> setServerUrl(ServerUrl serverUrl);

  Future<String> getServerUrl();

  Future<String> getServerSocket();
}
