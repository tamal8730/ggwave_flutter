import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ggwave_flutter_platform_interface.dart';

/// An implementation of [GgwaveFlutterPlatform] that uses method channels.
class MethodChannelGGWaveFlutter extends GGWaveFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ggwave_flutter');

  MethodChannelGGWaveFlutter({
    required Function(String message) onMessageReceivedListener,
    required Function() onPlaybackCompleteListener,
    required Function() onPlaybackStartListener,
    required Function() onPlaybackStopListener,
    required Function() onCaptureStartListener,
    required Function() onCaptureStopListener,
  }) {
    methodChannel.setMethodCallHandler(ggwaveMethodHandler);
    _onMessageReceived = onMessageReceivedListener;
    _onPlaybackComplete = onPlaybackCompleteListener;
    _onPlaybackStart = onPlaybackStartListener;
    _onPlaybackStop = onPlaybackStopListener;
    _onCaptureStart = onCaptureStartListener;
    _onCaptureStop = onCaptureStopListener;
  }

  late Function(String message) _onMessageReceived;
  late Function() _onPlaybackComplete;
  late Function() _onPlaybackStart;
  late Function() _onPlaybackStop;
  late Function() _onCaptureStart;
  late Function() _onCaptureStop;

  @override
  Future<void> togglePlayback(String message) async {
    await methodChannel.invokeMethod('togglePlayback', [message]);
  }

  @override
  Future<void> toggleCapture() async {
    await methodChannel.invokeMethod('toggleCapture');
  }

  @override
  Future<dynamic> ggwaveMethodHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'onMessageReceived':
        String message = methodCall.arguments as String;
        _onMessageReceived(message);
        break;
      case 'onPlaybackComplete':
        _onPlaybackComplete();
        break;
      case 'onCaptureStart':
        _onCaptureStart();
        break;
      case 'onCaptureStop':
      _onCaptureStop();
      break;
      case 'onPlaybackStart':
        _onPlaybackStart();
        break;
      case 'onPlaybackStop':
        _onPlaybackStop();
        break;
      default:
        throw MissingPluginException('notImplemented');
    }
  }
}
