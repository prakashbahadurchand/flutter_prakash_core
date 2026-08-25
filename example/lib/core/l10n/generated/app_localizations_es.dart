// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Aplicación Empresarial Offline First';

  @override
  String get homeTitle => 'Arquitectura Empresarial de Formularios y Listas';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get register => 'Registrarse';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get submit => 'Enviar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get search => 'Buscar...';

  @override
  String get retry => 'Reintentar';

  @override
  String get noItemsFound => 'No se encontraron elementos';

  @override
  String welcomeUser(String name) {
    return '¡Bienvenido, $name!';
  }
}
