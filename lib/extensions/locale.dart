part of '../aio.dart';

/// This extension provides a way to get the current locale of the app.
///
/// The locale is stored in the app preferences. (key: `_locale`)
/// If no locale is set, the platform locale is used.
///
/// To get the current locale, use `App().locale`.
extension AppLocale on App {
  static final _locale = Expando<Locale>();

  Locale get locale {
    final Prefs prefs = App().prefs;
    String? locale = prefs.getString(SPKeys._locale);

    // Use preferred locale
    if (locale != null) {
      final String languageCode = locale.split("_").first;
      final String countryCode = locale.split("_").last;

      _locale[this] = Locale(languageCode, countryCode);
      // return Locale("fr", "FR");
      return _locale[this]!;
    }

    // Use platform locale
    final String defaultLocale = Platform.localeName;
    final String languageCode = defaultLocale.split("_").first;
    final String countryCode = defaultLocale.split("_").last;

    prefs.setString(SPKeys._locale, defaultLocale);
    _locale[this] = Locale(languageCode, countryCode);
    return _locale[this]!;
  }
}
