import 'package:flutter_prakash/src/loggers/flutter_logger.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// User Messaging Platform (UMP) consent manager for handling GDPR / CCPA privacy consents.
class AdMobConsentManager {
  AdMobConsentManager._();

  /// Requests consent information and shows privacy consent form if required by law.
  static Future<void> requestConsent({
    bool tagForUnderAgeOfConsent = false,
    List<String>? testDeviceIds,
    void Function(FormError? error)? onConsentComplete,
  }) async {
    final params = ConsentRequestParameters(
      tagForUnderAgeOfConsent: tagForUnderAgeOfConsent,
      consentDebugSettings: ConsentDebugSettings(
        debugGeography: DebugGeography.debugGeographyEea,
        testIdentifiers: testDeviceIds,
      ),
    );

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          _loadAndShowConsentForm(onConsentComplete);
        } else {
          onConsentComplete?.call(null);
        }
      },
      (FormError error) {
        FlutterLogger.error(
          'Consent info update failed: ${error.message}',
          tag: 'ADMOB',
        );
        onConsentComplete?.call(error);
      },
    );
  }

  static void _loadAndShowConsentForm(
    void Function(FormError? error)? onConsentComplete,
  ) {
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        final status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          consentForm.show((FormError? error) {
            if (error != null) {
              FlutterLogger.error(
                'Consent form error: ${error.message}',
                tag: 'ADMOB',
              );
            }
            onConsentComplete?.call(error);
          });
        } else {
          onConsentComplete?.call(null);
        }
      },
      (FormError error) {
        FlutterLogger.error(
          'Failed to load consent form: ${error.message}',
          tag: 'ADMOB',
        );
        onConsentComplete?.call(error);
      },
    );
  }

  /// Reset consent state (useful during testing).
  static Future<void> reset() async {
    await ConsentInformation.instance.reset();
  }
}
