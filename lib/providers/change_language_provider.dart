import 'package:acakkata/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class ChangeLanguageProvider with ChangeNotifier {
  Locale? _currentLocale;

  Locale? get currentLocale => _currentLocale;
  changeLocale(String _locale) {
    _currentLocale = Locale(_locale);
    S.load(_currentLocale!);
    notifyListeners();
  }
}
