package com.github.tamal8730.ggwave_flutter;

import java.util.ArrayList;

import android.os.Handler;
import android.os.Looper;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** GgwaveFlutterPlugin */
public class GgwaveFlutterPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private GGWave ggWave;
  private final Handler uiThreadHandler = new Handler(Looper.getMainLooper());

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "ggwave_flutter");
    channel.setMethodCallHandler(this);
    ggWave = new GGWave();
    ggWave.init();

    ggWave.setOnMessageReceivedListener(message->{
      uiThreadHandler.post(() -> channel.invokeMethod("onMessageReceived", message));
    });

    ggWave.setOnPlaybackCompleteListener(() -> {
      channel.invokeMethod("onPlaybackComplete", null);
    });

  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("togglePlayback")) {
      ArrayList arguments = (ArrayList) call.arguments;
      String message = (String) arguments.get(0);
      togglePlayback(message);
      result.success(message);
    } else if(call.method.equals("toggleCapture")){
      toggleCapture();
      result.success(1);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private void toggleCapture(){
    GGWave.CaptureStatus status = ggWave.toggleCapture();
    switch (status) {
      case CAPTURING:
        channel.invokeMethod("onCaptureStart", null);
        break;
      case NOT_CAPTURING:
        channel.invokeMethod("onCaptureStop", null);
        break;
    }
  }

  private void togglePlayback(String message){
    ggWave.togglePlayback(message, new GGWave.AudioPlaybackCallback() {
      @Override
      public void onPlaybackStart() {
        channel.invokeMethod("onPlaybackStart", null);
      }

      @Override
      public void onPlaybackStop() {
        channel.invokeMethod("onPlaybackStop", null);
      }
    });
  }

}
