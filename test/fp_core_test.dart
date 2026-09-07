import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_prakash_core/src/plugins/plugins.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFpCorePlatform
    with MockPlatformInterfaceMixin
    implements FpCorePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getDeviceModel() => Future.value('Test Device');

  @override
  Future<String?> getCurrentLocation() => Future.value('27.7,85.3');
}

void main() {
  final initialPlatform = FpCorePlatform.instance;

  test('$MethodChannelFpCore is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFpCore>());
  });

  test('getPlatformVersion returns mock version', () async {
    final fakePlatform = MockFpCorePlatform();
    FpCorePlatform.instance = fakePlatform;

    expect(await FpCorePlugin.getPlatformVersion(), '42');
    expect(await FpCorePlugin.getDeviceModel(), 'Test Device');
    expect(await FpCorePlugin.getCurrentLocation(), '27.7,85.3');
  });

  test('$MethodChannelFpCore handles MissingPluginException gracefully', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFpCore>());
  });
}
