abstract class TheAppLanguage {
  static String appLanguage = 'en';

  static void updateLanguage(AppLanguage language) {
    appLanguage = language.appLanguage;
  }
}

abstract class AppLanguage {
  late String appLanguage;
}

class EnglishLanguage implements AppLanguage {
  @override
  String appLanguage = 'en';
}

class TurkishLanguage implements AppLanguage {
  @override
  String appLanguage = 'tr';
}

class NetherlandsLanguage implements AppLanguage {
  @override
  String appLanguage = 'nl';
}

class ArabicLanguage implements AppLanguage {
  @override
  String appLanguage = 'ar';
}

// Enum to define the available color themes.
enum ApplicationLanguage { en, nl, ar, tr }

// Extension to retrieve the color manager based on the selected theme.
extension ApplicationLanguageExtension on ApplicationLanguage {
  AppLanguage get appLanguage {
    switch (this) {
      case ApplicationLanguage.nl:
        return NetherlandsLanguage();
      case ApplicationLanguage.tr:
        return TurkishLanguage();
      case ApplicationLanguage.en:
        return EnglishLanguage();
      case ApplicationLanguage.ar:
        return ArabicLanguage();
      default:
        return EnglishLanguage();
    }
  }
}
