import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  LocaleController._(this._preferences, this._locale);

  static const String _languageCodeKey = 'selected_language_code';
  static const Locale defaultLocale = Locale('en');
  static const List<Locale> supportedLocales = [Locale('en'), Locale('kn')];

  final SharedPreferences _preferences;
  Locale _locale;

  Locale get locale => _locale;

  static Future<LocaleController> create() async {
    final preferences = await SharedPreferences.getInstance();
    final languageCode = preferences.getString(_languageCodeKey);
    final locale = _localeFromCode(languageCode) ?? defaultLocale;
    return LocaleController._(preferences, locale);
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.any(
      (item) => item.languageCode == locale.languageCode,
    )) {
      return;
    }

    if (_locale.languageCode == locale.languageCode) {
      return;
    }

    _locale = Locale(locale.languageCode);
    await _preferences.setString(_languageCodeKey, _locale.languageCode);
    notifyListeners();
  }

  static Locale? _localeFromCode(String? languageCode) {
    if (languageCode == null) {
      return null;
    }

    for (final locale in supportedLocales) {
      if (locale.languageCode == languageCode) {
        return locale;
      }
    }

    return null;
  }
}

class LocaleScope extends InheritedNotifier<LocaleController> {
  const LocaleScope({
    super.key,
    required LocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  static LocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'LocaleScope was not found in the widget tree.');
    return scope!.notifier!;
  }
}
