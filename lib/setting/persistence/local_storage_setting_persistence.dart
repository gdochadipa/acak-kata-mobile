import 'package:acakkata/models/server_url.dart';
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
  Future<bool> getIsLogin() async {
    final prefs = await instanceFuture;
    return prefs.getBool('login') ?? false;
  }

  @override
  Future<String> getLanguage() async {
    final prefs = await instanceFuture;
    return prefs.getString('choiceLang') ?? 'id';
  }

  @override
  Future<UserModel> getUserLogin() async {
    final prefs = await instanceFuture;
    UserModel _user = UserModel(
        id: prefs.getString('id'),
        name: prefs.getString('name'),
        email: prefs.getString('email'),
        username: prefs.getString('username'),
        userCode: prefs.getString('userCode'),
        token: prefs.getString('token'));
    return _user;
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
  Future<void> saveIsLogin(bool value) async {
    final prefs = await instanceFuture;
    await prefs.setBool('login', value);
  }

  @override
  Future<void> saveLanguage(String language) async {
    final prefs = await instanceFuture;
    await prefs.setString('choiceLang', language);
  }

  @override
  Future<void> saveUserLogin(UserModel user) async {
    final pref = await instanceFuture;
    pref.setBool('login', true);
    pref.setString('id', '${user.id}');
    pref.setString('name', user.name ?? '');
    pref.setString('email', '${user.email}');
    pref.setString('username', '${user.username}');
    pref.setString('userCode', '${user.userCode}');
    pref.setString('token', '${user.token}');
  }

  @override
  Future<double> getCalculatePercentByScore() async {
    final prefs = await instanceFuture;
    return prefs.getDouble('calculate_percent_by_score') ?? 60;
  }

  @override
  Future<double> getCalculatePercentByTime() async {
    final prefs = await instanceFuture;
    return prefs.getDouble('calculate_percent_by_time') ?? 60;
  }

  @override
  Future<void> setCalculatePercentByScore(double calculate) async {
    final prefs = await instanceFuture;
    prefs.setDouble('calculate_percent_by_score', calculate);
  }

  @override
  Future<void> setCalculatePercentByTime(double calculate) async {
    final prefs = await instanceFuture;
    prefs.setDouble('calculate_percent_by_time', calculate);
  }

  @override
  Future<String> getServerSocket() async {
    final prefs = await instanceFuture;
    return prefs.getString('set_socket') ?? "http://139.59.117.124:3000";
  }

  @override
  Future<String> getServerUrl() async {
    final prefs = await instanceFuture;
    return prefs.getString('set_url') ?? "http://139.59.117.124:3000";
  }

  @override
  Future<void> setServerUrl(ServerUrl serverUrl) async {
    final pref = await instanceFuture;
    pref.setString('set_url', "http://139.59.117.124:3000");
    pref.setString('set_socket', "http://139.59.117.124:3000");
  }
}
