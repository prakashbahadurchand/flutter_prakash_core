// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get appTitle => 'अफलाइन पहिलो इन्टरप्राइज एप';

  @override
  String get homeTitle => 'इन्टरप्राइज फारम र सूची आर्किटेक्चर';

  @override
  String get login => 'लगइन';

  @override
  String get register => 'दर्ता गर्नुहोस्';

  @override
  String get email => 'इमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get submit => 'पेश गर्नुहोस्';

  @override
  String get cancel => 'रद्द गर्नुहोस्';

  @override
  String get search => 'खोज्नुहोस्...';

  @override
  String get retry => 'पुन: प्रयास गर्नुहोस्';

  @override
  String get noItemsFound => 'कुनै वस्तु फेला परेन';

  @override
  String welcomeUser(String name) {
    return 'स्वागत छ, $name!';
  }
}
