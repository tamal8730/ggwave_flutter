// import 'package:flutter_test/flutter_test.dart';
// import 'package:ggwave_flutter/ggwave_flutter.dart';
// import 'package:ggwave_flutter/ggwave_flutter_platform_interface.dart';
// import 'package:ggwave_flutter/ggwave_flutter_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockGgwaveFlutterPlatform
//     with MockPlatformInterfaceMixin
//     implements GgwaveFlutterPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final GgwaveFlutterPlatform initialPlatform = GgwaveFlutterPlatform.instance;
//
//   test('$MethodChannelGgwaveFlutter is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelGgwaveFlutter>());
//   });
//
//   test('getPlatformVersion', () async {
//     GgwaveFlutter ggwaveFlutterPlugin = GgwaveFlutter();
//     MockGgwaveFlutterPlatform fakePlatform = MockGgwaveFlutterPlatform();
//     GgwaveFlutterPlatform.instance = fakePlatform;
//
//     expect(await ggwaveFlutterPlugin.getPlatformVersion(), '42');
//   });
// }
