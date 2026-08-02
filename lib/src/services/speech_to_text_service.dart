import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Voice-to-text listener helper for search bars and audio input.
class SpeechToTextService extends ChangeNotifier {
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _lastWords = '';
  bool _isListening = false;

  String get lastWords => _lastWords;
  bool get isListening => _isListening;
  bool get isAvailable => _speech.isAvailable;

  /// Initializes the recognizer and enables the "speech can be listened" flag.
  Future<bool> initialize() async {
    final ok = await _speech.initialize(
      onStatus: (status) {
        // status is e.g. 'listening' / 'notListening'.
      },
      onError: (error) {
        _isListening = false;
        notifyListeners();
      },
    );
    if (ok) notifyListeners();
    return ok;
  }

  /// Starts listening; every recognized word is published to [lastWords].
  Future<void> listen({
    String localeId = 'en_US',
    void Function(String recognizedWords)? onResult,
  }) async {
    if (!_speech.isAvailable && !await initialize()) return;

    _isListening = true;
    notifyListeners();

    await _speech.listen(
      listenOptions: stt.SpeechListenOptions(
        localeId: localeId,
        listenFor: const Duration(seconds: 15),
      ),
      onResult: (result) {
        _lastWords = result.recognizedWords;
        onResult?.call(_lastWords);
        notifyListeners();
      },
    );
  }

  Future<void> stop() async {
    await _speech.stop();
    _isListening = false;
    notifyListeners();
  }
}
