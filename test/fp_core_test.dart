import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_prakash_core/src/plugins/plugins.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFpCorePlatform
    with MockPlatformInterfaceMixin
    implements FpCorePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
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
  });
}
