import 'package:flutter_prakash_core/fp_core.dart';
import 'package:flutter_prakash_core_example/features/common/data/models/feedback_request_model.dart';
import 'package:flutter_prakash_core_example/features/common/data/models/legal_document_model.dart';

@lazySingleton
class CommonLocalDataSource {
  const CommonLocalDataSource();

  Future<LegalDocumentModel> getPrivacyPolicy() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const LegalDocumentModel(
      title: 'Privacy Policy',
      content: '''
# Privacy Policy

**Effective Date:** January 1, 2026

## 1. Introduction
Welcome to flutter_prakash_core. We respect your privacy and are committed to protecting your personal data.

## 2. Information We Collect
- Device information and operating system version.
- Crash reports and application diagnostic telemetry.
- Preferences (Theme Mode, Selected Locale).

## 3. How We Use Information
We use your information solely to ensure optimal application performance and deliver a smooth user experience.

## 4. Contact Us
If you have any questions, please reach out via our feedback channel.
''',
      lastUpdated: 'January 1, 2026',
    );
  }

  Future<LegalDocumentModel> getTermsAndConditions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const LegalDocumentModel(
      title: 'Terms & Conditions',
      content: '''
# Terms and Conditions

**Effective Date:** January 1, 2026

## 1. Acceptance of Terms
By downloading, installing, or using this application, you agree to be bound by these Terms.

## 2. License Grant
Subject to your compliance, you are granted a limited, non-exclusive, non-transferable license.

## 3. Disclaimer of Warranties
This software is provided "AS IS", without warranty of any kind, express or implied.

## 4. Changes to Terms
We reserve the right to modify these Terms at any time.
''',
      lastUpdated: 'January 1, 2026',
    );
  }

  Future<bool> submitFeedback(FeedbackRequestModel request) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }
}
