// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'ऑफ़लाइन-फ़र्स्ट एंटरप्राइज़ ऐप';

  @override
  String get homeTitle => 'एंटरप्राइज़ फ़ॉर्म एवं सूची आर्किटेक्चर';

  @override
  String get login => 'लॉगिन';

  @override
  String get register => 'रजिस्टर';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get submit => 'सबमिट करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get search => 'खोजें...';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get noItemsFound => 'कोई आइटम नहीं मिला';

  @override
  String welcomeUser(String name) {
    return 'स्वागत है, $name!';
  }
}
