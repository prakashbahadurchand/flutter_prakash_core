import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';

@injectable
class ThemeCubit extends BaseCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void updateThemeMode(ThemeMode mode) {
    safeEmit(mode);
    emitEffect(ShowToastEffect('Theme switched to ${mode.name.toUpperCase()}'));
  }
}
