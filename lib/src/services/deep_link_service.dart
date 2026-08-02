import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Deep-linking and sharing helper built on `url_launcher` and `share_plus`.
///
/// Handles external links, `mailto:`, `tel:`, and custom app-scheme URLs in a
/// single place, taking care of `canLaunch` checks behind `launchMode`.
class DeepLinkService {
  const DeepLinkService._();

  /// Opens a URL using the given [LaunchMode] (defaults to in-app browser where
  /// available). Returns whether it could be launched.
  static Future<bool> launch(
    String url, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    final uri = Uri.parse(url);
    if (!await canLaunchUri(uri)) return false;
    return launchUri(uri, mode: mode);
  }

  static Future<bool> canLaunchUri(Uri uri) => canLaunchUrl(uri);
  static Future<bool> launchUri(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) => launchUrl(uri, mode: mode);

  /// Opens a `tel:` dialer for a phone number.
  static Future<bool> call(String phoneNumber) => launch('tel:$phoneNumber');

  /// Composes an email via `mailto:`.
  static Future<bool> email(String to, {String? subject, String? body}) {
    final base = 'mailto:$to';
    final params = <String>[];
    if (subject != null) params.add('subject=$subject');
    if (body != null) params.add('body=$body');
    return launch(params.isEmpty ? base : '$base?${params.join('&')}');
  }

  /// Shares text/URL with the OS share sheet.
  static Future<void> share(String text, {String? subject}) async {
    await SharePlus.instance.share(ShareParams(text: text, subject: subject));
  }
}
