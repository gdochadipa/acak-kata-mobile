import 'package:flutter/cupertino.dart';

class ChangeLanguageProvider with ChangeNotifier {
  Locale _currentLocale = new Locale('en');

  Locale get currentLocale => _currentLocale;
  changeLocale(String _locale) {
    this._currentLocale = new Locale(_locale);
    notifyListeners();
  }
}
