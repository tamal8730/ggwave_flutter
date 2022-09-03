import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'ggwave_flutter_method_channel.dart';

abstract class GGWaveFlutterPlatform extends PlatformInterface {
  /// Constructs a GgwaveFlutterPlatform.
  GGWaveFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static GGWaveFlutterPlatform _instance = MethodChannelGGWaveFlutter(
    onMessageReceivedListener: (String message) {
      _instance._onMessageReceived?.call(message);
    },
    onPlaybackCompleteListener: () {
      _instance._onPlaybackComplete?.call();
    },
    onPlaybackStartListener: () {
      _instance._onPlaybackStart?.call();
    },
    onPlaybackStopListener: () {
      _instance._onPlaybackStop?.call();
    },
    onCaptureStartListener: () {
      _instance._onCaptureStart?.call();
    },
    onCaptureStopListener: () {
      _instance._onCaptureStop?.call();
    },
  );

  /// The default instance of [GgwaveFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelGgwaveFlutter].
  static GGWaveFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GgwaveFlutterPlatform] when
  /// they register themselves.
  static set instance(GGWaveFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Function(String message)? _onMessageReceived;
  Function()? _onPlaybackComplete;
  Function()? _onPlaybackStart;
  Function()? _onPlaybackStop;
  Function()? _onCaptureStart;
  Function()? _onCaptureStop;

  void setOnMessageReceivedListener(
      Function(String message) onMessageReceivedListener) {
    _onMessageReceived = onMessageReceivedListener;
  }

  void setOnPlaybackCompleteListener(Function() onPlaybackCompleteListener) {
    _onPlaybackComplete = onPlaybackCompleteListener;
  }

  void setOnPlaybackStartListener(Function() onPlaybackStartListener) {
    _onPlaybackStart = onPlaybackStartListener;
  }

  void setOnPlaybackStopListener(Function() onPlaybackStopListener) {
    _onPlaybackStop = onPlaybackStopListener;
  }

  void setOnCaptureStartListener(Function() onCaptureStartListener) {
    _onCaptureStart = onCaptureStartListener;
  }

  void setOnCaptureStopListener(Function() onCaptureStopListener) {
    _onCaptureStop = onCaptureStopListener;
  }

  Future<dynamic> ggwaveMethodHandler(MethodCall methodCall);

  Future<void> togglePlayback(String message);

  Future<void> toggleCapture();
}
