import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Represents a developer custom promotional ad (used as an offline fallback or direct promotion).
class CustomAdModel {
  const CustomAdModel({
    required this.headerInfo,
    required this.appName,
    required this.appPackageName,
    required this.appMessage,
    required this.appDetails,
    required this.appIconPath,
    this.appStoreUrl,
    this.playStoreUrl,
    this.isAssetImage = true,
    this.dialogOkText = 'ठिक छ',
    this.dialogDownloadText = 'डाउनलोड गर्नुहोस्',
    this.installButtonText = '*** INSTALL NOW ***',
    this.primaryColor = Colors.indigo,
    this.badgeText = 'Ad',
  });

  /// Header subtitle or promotional badge text (e.g. 'Recommended for you', 'Special for you').
  final String headerInfo;

  /// Display name of the promoted app / product.
  final String appName;

  /// Package name / bundle identifier (e.g. 'com.example.app').
  final String appPackageName;

  /// Catchy short message / slogan.
  final String appMessage;

  /// Detailed description / full details of the promoted application.
  final String appDetails;

  /// Asset path or network URL of the app icon.
  final String appIconPath;

  /// Optional iOS App Store direct URL (fallback to web search if omitted).
  final String? appStoreUrl;

  /// Optional Google Play Store direct URL (fallback to package name link if omitted).
  final String? playStoreUrl;

  /// Whether [appIconPath] is a local asset path (true) or network URL (false).
  final bool isAssetImage;

  /// Localized text for dialog dismiss button (default: 'ठिक छ').
  final String dialogOkText;

  /// Localized text for dialog download action button (default: 'डाउनलोड गर्नुहोस्').
  final String dialogDownloadText;

  /// Localized text for native banner install button (default: '*** INSTALL NOW ***').
  final String installButtonText;

  /// Brand/Accent color used for headers, buttons, and borders.
  final Color primaryColor;

  /// Small corner badge tag (e.g. 'Ad' / 'प्रायोजित').
  final String badgeText;

  /// Opens the application listing on Google Play Store (Android) or App Store (iOS).
  Future<bool> openPlayStore() async {
    return openStore();
  }

  /// Opens the store listing across Android, iOS, or Web.
  Future<bool> openStore() async {
    try {
      if (kIsWeb) {
        final webUrl =
            playStoreUrl ??
            'https://play.google.com/store/apps/details?id=$appPackageName';
        return await launchUrl(
          Uri.parse(webUrl),
          mode: LaunchMode.externalApplication,
        );
      }

      if (Platform.isAndroid) {
        final androidUrl =
            playStoreUrl ??
            'https://play.google.com/store/apps/details?id=$appPackageName';
        return await launchUrl(
          Uri.parse(androidUrl),
          mode: LaunchMode.externalNonBrowserApplication,
        );
      } else if (Platform.isIOS) {
        if (appStoreUrl != null && appStoreUrl!.isNotEmpty) {
          return await launchUrl(
            Uri.parse(appStoreUrl!),
            mode: LaunchMode.externalApplication,
          );
        }
      }
    } catch (_) {}
    return false;
  }
}
