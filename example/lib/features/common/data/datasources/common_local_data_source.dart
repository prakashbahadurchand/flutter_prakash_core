import 'package:flutter_prakash_core_example/features/common/data/models/legal_document_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CommonLocalDataSource {
  Future<LegalDocumentModel> getPrivacyPolicy() async {
    return const LegalDocumentModel(
      title: 'Privacy Policy',
      lastUpdated: 'August 2026',
      content:
          'Flutter Prakash takes your privacy seriously. We process data securely on-device with zero untracked data leaks. '
          'We do not collect personal information without your explicit consent.\n\n'
          '1. Data Collection\n'
          'We only collect data that is necessary for the core functionality of the application. '
          'This may include device information and crash reports to improve stability.\n\n'
          '2. Data Usage\n'
          'Your data is never sold to third parties. It is exclusively used to provide and improve the service.\n\n'
          '3. Security\n'
          'We implement industry-standard encryption to protect your data both in transit and at rest.\n\n'
          'If you have any questions about this Privacy Policy, please contact our support team.',
    );
  }

  Future<LegalDocumentModel> getTermsAndConditions() async {
    return const LegalDocumentModel(
      title: 'Terms of Service',
      lastUpdated: 'August 2026',
      content:
          'Please read these Terms of Service carefully before using the Flutter Prakash application.\n\n'
          '1. Acceptance of Terms\n'
          'By accessing or using the application, you agree to be bound by these Terms. '
          'If you disagree with any part of the terms, you do not have permission to access the service.\n\n'
          '2. License Use\n'
          'We grant you a personal, non-exclusive, non-transferable, limited privilege to enter and use the Application. '
          'You may not modify, copy, distribute, transmit, display, perform, reproduce, publish, license, create derivative works from, transfer, or sell any information, software, products or services obtained from the Application.\n\n'
          '3. Disclaimer\n'
          'The materials on the application are provided on an "as is" basis. '
          'We make no warranties, expressed or implied, and hereby disclaim and negate all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.\n\n'
          '4. Limitations\n'
          'In no event shall Flutter Prakash or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on the application.',
    );
  }
}
