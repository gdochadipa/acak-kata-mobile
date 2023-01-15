import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/service/language_service.dart';
import 'package:acakkata/setting/persistence/setting_persistence.dart';
import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  List<LanguageModel> _language = [];
  List<LanguageModel> get languages => _language;
  final SettingsPersistence _persistence;

  ValueNotifier<String> baseUrl = ValueNotifier("");

  LanguageProvider({required SettingsPersistence persistence})
      : _persistence = persistence;

  Future<void> loadStateFromPersistence() async {
    _persistence.getServerUrl().then((value) => baseUrl.value = value);
  }

  set languages(List<LanguageModel> languages) {
    _language = languages;
    notifyListeners();
  }

  Future<void> getLanguages() async {
    try {
      List<LanguageModel> languages =
          await LanguageService(serverUrl: baseUrl.value).getLanguage();
      _language = languages;
    } catch (e) {
      print(e);
    }
  }
}
