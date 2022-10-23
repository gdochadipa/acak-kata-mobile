import 'package:acakkata/models/user_model.dart';
import 'package:acakkata/setting/persistence/setting_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageSettingPersistence extends SettingsPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  @override
  Future<bool> getMusicOn() async {
    final prefs = await instanceFuture;
    return prefs.getBool('musicOn') ?? true;
  }

  @override
  Future<bool> getMuted({required bool defaultValue}) async {
    final prefs = await instanceFuture;
    return prefs.getBool('mute') ?? defaultValue;
  }

  @override
  Future<bool> getSoundsOn() async {
    final prefs = await instanceFuture;
    return prefs.getBool('soundsOn') ?? true;
  }

  @override
  Future<bool> getIsLogin() {
    // TODO: implement getIsLogin
    throw UnimplementedError();
  }

  @override
  Future<String> getLanguage() {
    // TODO: implement getLanguage
    throw UnimplementedError();
  }

  @override
  Future<UserModel> getUserLogin() {
    // TODO: implement getUserLogin
    throw UnimplementedError();
  }

  @override
  Future<void> saveMusicOn(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('musicOn', value);
  }

  @override
  Future<void> saveMuted(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('mute', value);
  }

  @override
  Future<void> saveSoundsOn(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('soundsOn', value);
  }

  @override
  Future<void> saveIsLogin(bool value) {
    // TODO: implement saveIsLogin
    throw UnimplementedError();
  }

  @override
  Future<void> saveLanguage(String language) {
    // TODO: implement saveLanguage
    throw UnimplementedError();
  }

  @override
  Future<void> saveUserLogin(UserModel userModel) {
    // TODO: implement saveUserLogin
    throw UnimplementedError();
  }
}
