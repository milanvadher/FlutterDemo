import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsBloc {
  static final isDarkTheme = BehaviorSubject<bool>();

  static changeTheme(bool isDark) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('isDarkTheme', isDark);
    isDarkTheme.sink.add(isDark);
  }

  static setAppThemeOnLoad() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    isDarkTheme.sink.add(_prefs.getBool('isDarkTheme') ?? false);
  }

  static dispose() {
    isDarkTheme.close();
  }
}
