import '../../../data/local_storage/shared_local.dart';
import 'general_strings.dart';

class VariablesManager {
  static bool isDark = false;
  static String? currentUser =
      SharedPref.prefs.getString(GeneralStrings.currentUser);
}
