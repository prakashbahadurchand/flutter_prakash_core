import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_prakash_ads/flutter_prakash_ads.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart'
    hide SmartNativeAdView, SmartBannerAdView;
import 'package:flutter_prakash_core_example/core/router/app_router.dart';

class DashboardThirdTabView extends StatelessWidget {
  const DashboardThirdTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'UI & Interaction Utilities',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              avatar: const Icon(Icons.info_outline, size: 18),
              label: const Text('Info Toast'),
              onPressed: () => Toast.info('Informational notification!'),
            ),
            ActionChip(
              avatar: const Icon(
                Icons.check_circle_outline,
                size: 18,
                color: Colors.green,
              ),
              label: const Text('Success Toast'),
              onPressed: () => Toast.success('Action finished successfully!'),
            ),
            ActionChip(
              avatar: const Icon(
                Icons.warning_amber_rounded,
                size: 18,
                color: Colors.orange,
              ),
              label: const Text('Warning Toast'),
              onPressed: () => Toast.warning('Please be cautious!'),
            ),
            ActionChip(
              avatar: const Icon(
                Icons.error_outline,
                size: 18,
                color: Colors.red,
              ),
              label: const Text('Error Toast'),
              onPressed: () => Toast.error('Something went wrong!'),
            ),
            ActionChip(
              avatar: const Icon(Icons.hourglass_top_rounded, size: 18),
              label: const Text('Loading Overlay (2s)'),
              onPressed: () => LoadingOverlay.show(autoHideInSeconds: 2),
            ),
            ActionChip(
              avatar: const Icon(Icons.terminal_rounded, size: 18),
              label: const Text('Test Logger'),
              onPressed: () {
                logInfo('Testing logInfo with data', tag: 'EXAMPLE');
                logDebug({'user': Fake.fullName, 'id': Fake.id}, tag: 'DEBUG');
                logWarn('Sample memory warning test', tag: 'WARN');
                Toast.info('Logs emitted to console');
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'File & Web Containers',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.image_outlined, color: Colors.blue),
            title: const Text('Image Preview (Interactive Zoom)'),
            subtitle: const Text('Opens FilePreviewContainer with pan & zoom'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              FilePreviewContainer.show(
                context,
                filePath: 'https://picsum.photos/800/1200',
                fileType: FileType.image,
                sourceType: FileSourceType.network,
                title: 'Sample Image Preview',
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(
              Icons.picture_as_pdf_outlined,
              color: Colors.red,
            ),
            title: const Text('PDF Document Viewer'),
            subtitle: const Text('Opens FilePreviewContainer in PDF mode'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              FilePreviewContainer.show(
                context,
                filePath:
                    'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                fileType: FileType.pdf,
                sourceType: FileSourceType.network,
                title: 'Sample PDF Document',
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.public, color: Colors.indigo),
            title: const Text('In-App Web View'),
            subtitle: const Text(
              'Opens InAppWebViewContainer with progress & controls',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              InAppWebViewContainer.show(
                context,
                initialUrl: 'https://flutter.dev',
                title: 'Flutter Official Website',
                progressBarColor: Colors.indigoAccent,
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Network & Analytics Engines',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.bolt, color: Colors.teal),
            title: const Text('Supabase Engine Status'),
            subtitle: const Text('Configured for Auth, Realtime DB & Storage'),
            onTap: () {
              Toast.info('Supabase Engine is active & ready');
            },
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.analytics, color: Colors.blue),
            title: const Text('Firebase Analytics Log'),
            subtitle: const Text('Tap to send custom event: test_button_click'),
            onTap: () {
              FirebaseAnalyticsManager.logEvent(
                name: 'test_button_click',
                parameters: {'screen': 'dashboard_network'},
              );
              Toast.info('Logged Analytics Event');
            },
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.bug_report, color: Colors.red),
            title: const Text('Record Non-Fatal Crashlytics Error'),
            subtitle: const Text(
              'Captures error report via FirebaseCrashlyticsManager',
            ),
            onTap: () {
              FirebaseCrashlyticsManager.recordError(
                Exception('Test non-fatal exception'),
                StackTrace.current,
                reason: 'Dashboard manual test',
              );
              Toast.error('Recorded Crashlytics Error');
            },
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.monetization_on_rounded, color: Colors.amber),
            title: const Text('Open AdMob Showcase'),
            subtitle: const Text('Banners, Native Ads, Interstitials, Rewarded Video & ILRD Telemetry'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.router.push(const AdMobShowcaseRoute());
            },
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Inline Smart Native Ad (Small Template, 90px):',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        const SmartNativeAdView(
          templateType: TemplateType.small,
          cornerRadius: 12.0,
        ),
      ],
    );
  }
}
