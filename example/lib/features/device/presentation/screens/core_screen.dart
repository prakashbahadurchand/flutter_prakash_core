import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_prakash/flutter_prakash.dart';

import '../../../../locator.dart';
import '../../../../shared/widgets/wrappers.dart';
import '../../application/device_info_cubit.dart';
import '../../application/device_info_state.dart';

/// Presents the Core Engine + Device feature.
///
/// Clean Architecture **presentation** layer: no direct platform/service
/// calls — state changes are driven by [DeviceInfoCubit].
class CoreScreen extends StatelessWidget {
  const CoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeviceInfoCubit>(
      create: (_) =>
          getIt<DeviceInfoCubit>()..load(),
      child: const _CoreView(),
    );
  }
}

class _CoreView extends StatelessWidget {
  const _CoreView();

  @override
  Widget build(BuildContext context) {
    final logger = getIt<AppLogger>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DemoCard(
          title: 'PrakashEngine Bootstrap',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Engine initialized with REST, Media, Storage, AdMob and '
                'Native channels. Dependencies and feature use cases are wired '
                'through the GetIt container below.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  logger.info('Hello from AppLogger');
                  context.showSnackBar('Log entry written via AppLogger');
                },
                icon: const Icon(Icons.troubleshoot),
                label: const Text('Write a log'),
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'Native Platform Bridge (Clean Arch)',
          child: BlocBuilder<DeviceInfoCubit, DeviceInfoState>(
            builder: (context, state) => switch (state) {
              DeviceInfoLoading() => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              DeviceInfoError(:final message) => Text(
                message,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              DeviceInfoLoaded(:final info) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoRow(label: 'Platform', value: info.platformVersion),
                  InfoRow(label: 'Device', value: info.deviceModel),
                  InfoRow(label: 'Location', value: info.locationLabel),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => context
                            .read<DeviceInfoCubit>()
                            .load(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Re-read'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          await context
                              .read<DeviceInfoCubit>()
                              .requestLocation();
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                info.locationGranted
                                    ? 'Location permission granted'
                                    : 'Permission denied',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.my_location),
                        label: const Text('Request Location'),
                      ),
                    ],
                  ),
                ],
              ),
            },
          ),
        ),
        DemoCard(
          title: 'Utility Services',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.open_in_new),
                label: const Text('Open URL'),
                onPressed: () => DeepLinkService.launch('https://flutter.dev'),
              ),
              ActionChip(
                avatar: const Icon(Icons.share),
                label: const Text('Share'),
                onPressed: () =>
                    DeepLinkService.share('Shared from flutter_prakash!'),
              ),
              ActionChip(
                avatar: const Icon(Icons.add_to_home_screen),
                label: const Text('Home Widget'),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await HomeWidgetService.updateData({'score': 42});
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Home widget payload updated'),
                    ),
                  );
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.notifications),
                label: const Text('Notify'),
                onPressed: () async {
                  await LocalNotificationService.initialize();
                  await LocalNotificationService.show(
                    1,
                    'Hello',
                    'From flutter_prakash notifications',
                  );
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.camera),
                label: const Text('Check Camera'),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final ok = await PermissionService.isGranted(
                    PermissionService.camera,
                  );
                  messenger.showSnackBar(
                    SnackBar(content: Text('Camera granted: $ok')),
                  );
                },
              ),
            ],
          ),
        ),
        DemoCard(
          title: 'String & DateTime Extensions',
          child: Text(
            '${'flutter prakash'.capitalize()} · ✅ '
            'Email valid: ${'abc@x.co'.isValidEmail} · Phone valid: '
            '${'+9779800000000'.isValidPhone}\n'
            'Relative time: '
            '${DateTime.now().subtract(const Duration(minutes: 5)).toRelativeTime()}',
          ),
        ),
      ],
    );
  }
}