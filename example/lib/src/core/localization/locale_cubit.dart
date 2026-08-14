import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';

@injectable
class LocaleCubit extends BaseCubit<Locale> {
  LocaleCubit() : super(const Locale('en', 'US'));

  void updateLocale(Locale locale) {
    safeEmit(locale);
    emitEffect(ShowToastEffect('Language changed to ${locale.languageCode.toUpperCase()}'));
  }
}
