import 'package:acakkata/models/language_model.dart';
import 'package:acakkata/service/language_service.dart';
import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  List<LanguageModel> _language = [];
  List<LanguageModel> get languages => _language;

  set languages(List<LanguageModel> languages) {
    _language = languages;
    notifyListeners();
  }

  Future<void> getLanguages() async {
    try {
      List<LanguageModel> languages = await LanguageService().getLanguage();
      _language = languages;
    } catch (e) {
      print(e);
    }
  }
}
