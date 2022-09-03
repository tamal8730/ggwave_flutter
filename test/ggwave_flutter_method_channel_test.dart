// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:ggwave_flutter/ggwave_flutter_method_channel.dart';
//
// void main() {
//   MethodChannelGgwaveFlutter platform = MethodChannelGgwaveFlutter();
//   const MethodChannel channel = MethodChannel('ggwave_flutter');
//
//   TestWidgetsFlutterBinding.ensureInitialized();
//
//   setUp(() {
//     channel.setMockMethodCallHandler((MethodCall methodCall) async {
//       return '42';
//     });
//   });
//
//   tearDown(() {
//     channel.setMockMethodCallHandler(null);
//   });
//
//   test('getPlatformVersion', () async {
//     expect(await platform.getPlatformVersion(), '42');
//   });
// }
