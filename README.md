# ggwave_flutter

ggwave_flutter is a Flutter plugin for the [ggwave data-over-sound library](https://github.com/ggerganov/ggwave).

## About
With this library, you can send and receive small amounts of data via sound. The message payload is encoded as a audio wave. The sender plays this audio through the phone speaker and the receiver listens for the audio with the in-built microphone and then decodes the message from it.

## Getting Started
First we create a `GGWaveFlutter` object
```
GGWaveFlutter ggwave = GGWaveFlutter(
	GGWaveFlutterCallbacks(  
		  onMessageReceived: (message){},  
		  onPlaybackStart: (){},  
		  onPlaybackStop: (){},  
		  onPlaybackComplete: (){},  
		  onCaptureStart: (){},  
		  onCaptureStop: (){},  
	),  
);
```
The `GGWaveFlutter` constructor takes in a `GGWaveFlutterCallbacks` object. This is just a bunch of callbacks encapsulated together in a single class.

| Callback | Arguments | Description |
|--|--|--|
|`onMessageReceived`  | String message  | Invoked when a message is received from another device. **Make sure to grant microphone access permissions.** |
|`onPlaybackStart`  | -- | Invoked when the data has been encoded and the audio just starts playing. |
|`onPlaybackStop`  | -- | Invoked when the audio playback is interrupted midway. |
|`onPlaybackComplete`  |--  | Invoked when the audio playback is complete. That is, when the complete data has been sent out as audio.|
|`onCaptureStart`  |--  | Invoked when the device starts listening for the data-encoded audio. |
|`onCaptureStop`  |--  | Invoked when the device stops listening for the data-encoded audio. |

The `GGWaveFlutter` class has two methods, one to send the message, and the other to start/stop listening for messages.
| Method signature  | Description |
|--|--|
| `Future<void> togglePlayback(String message)` | Calling this method will start playing an audio with the message encoded in it. If this method is called again before the current audio playback completes, it will stop the playback and no data will be transmitted. |
| `Future<void> toggleCapture()` | This method puts the device in listening(or capturing) mode. If already in listening mode, calling this method again would stop listening. **Make sure to grant microphone permissions to start listening for messages.** |

## Limitations
Currently, only android is supported.

## Credits
Thanks to [Georgi Gerganov](https://github.com/ggerganov) for his [ggwave](https://github.com/ggerganov/ggwave) library. 