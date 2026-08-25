// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Offline First Enterprise App';

  @override
  String get homeTitle => 'Enterprise Form & List Architecture';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get submit => 'Submit';

  @override
  String get cancel => 'Cancel';

  @override
  String get search => 'Search...';

  @override
  String get retry => 'Retry';

  @override
  String get noItemsFound => 'No items found';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name!';
  }
}
