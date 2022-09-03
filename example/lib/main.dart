import 'package:flutter/material.dart';
import 'package:ggwave_flutter/ggwave_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GGWaveFlutter _ggwave;
  late TextEditingController _messageEditingController;

  String _receivedMessage = "";
  bool _isListening = false;
  bool _sendButtonEnabled = false;
  String _sendButtonLabel = "Send";
  String _listenButtonLabel = "Start listening";

  @override
  void initState() {
    super.initState();

    _messageEditingController = TextEditingController();

    _ggwave = GGWaveFlutter(
      GGWaveFlutterCallbacks(
        onMessageReceived: _onMessageReceived,
        onPlaybackStart: _onPlaybackStart,
        onPlaybackStop: _onPlaybackStop,
        onPlaybackComplete: _onPlaybackComplete,
        onCaptureStart: _onCaptureStart,
        onCaptureStop: _onCaptureStop,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _messageEditingController.dispose();
  }

  void _onMessageReceived(String message) {
    setState(() {
      _receivedMessage = message;
      _sendButtonEnabled = true;
      _sendButtonLabel = "Send";
    });
  }

  void _onPlaybackStart() {
    setState(() {
      _sendButtonEnabled = false;
      _sendButtonLabel = "Sending...";
    });
  }

  void _onPlaybackStop() {
    setState(() {
      _sendButtonEnabled = true;
      _sendButtonLabel = "Send";
    });
  }

  void _onPlaybackComplete() {
    setState(() {
      _sendButtonEnabled = true;
      _sendButtonLabel = "Send";
    });
  }

  void _onCaptureStart() {
    setState(() {
      _isListening = true;
      _sendButtonEnabled = false;
      _listenButtonLabel = "Stop listening";
    });
  }

  void _onCaptureStop() {
    setState(() {
      _isListening = false;
      _sendButtonEnabled = true;
      _listenButtonLabel = "Start listening";
      _receivedMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('GGWave Flutter')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isListening)
                  Text(
                    _receivedMessage,
                    style: const TextStyle(fontSize: 24),
                  )
                else
                  Expanded(
                    child: TextField(
                      onChanged: (message) {
                        // disable send button if message is empty
                        if (message.isEmpty && _sendButtonEnabled) {
                          setState(() => _sendButtonEnabled = false);
                        }
                        // disable send button if message is not empty
                        else if (message.isNotEmpty && !_sendButtonEnabled) {
                          setState(() => _sendButtonEnabled = true);
                        }
                      },
                      controller: _messageEditingController,
                      style: const TextStyle(fontSize: 24),
                      decoration: const InputDecoration(
                          hintStyle: TextStyle(fontSize: 24),
                          hintText: "Your message",
                          border: InputBorder.none),
                    ),
                  ),
                const SizedBox(height: 54),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: _isListening || !_sendButtonEnabled
                      ? null
                      : () => _ggwave
                          .togglePlayback(_messageEditingController.text),
                  child: Text(_sendButtonLabel),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => _ggwave.toggleCapture(),
                  child: Text(_listenButtonLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
