import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_prakash_core/src/plugins/plugins.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPrakashCorePlatform
    with MockPlatformInterfaceMixin
    implements FlutterPrakashCorePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final initialPlatform = FlutterPrakashCorePlatform.instance;

  test('$MethodChannelFlutterPrakashCore is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterPrakashCore>());
  });

  test('getPlatformVersion returns mock version', () async {
    final fakePlatform = MockFlutterPrakashCorePlatform();
    FlutterPrakashCorePlatform.instance = fakePlatform;

    expect(await FlutterPrakashCorePlugin.getPlatformVersion(), '42');
  });
}
