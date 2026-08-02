import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Centralized audio playback controller.
///
/// Provides direct access to the underlying [AudioPlayer] and its reactive
/// streams (`onPositionChanged`, `onDurationChanged`, `onPlayerStateChanged`)
/// so UI widgets can build playback controls without owning player instances.
class AudioPlayerService {
  AudioPlayerService._();
  static final AudioPlayerService instance = AudioPlayerService._();

  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  Future<void> playUrl(String url) async {
    await _player.play(UrlSource(url));
  }

  Future<void> playBytes(Uint8List bytes) async {
    await _player.play(BytesSource(bytes));
  }

  Future<void> playLocal(String path) async {
    await _player.play(DeviceFileSource(path));
  }

  Future<void> playAsset(String path) async {
    await _player.play(AssetSource(path));
  }

  Future<void> pause() => _player.pause();

  Future<void> resume() => _player.resume();

  Future<void> stop() => _player.stop();

  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> setVolume(double volume) => _player.setVolume(volume);

  Future<void> setPlaybackRate(double rate) => _player.setPlaybackRate(rate);

  Future<void> dispose() => _player.dispose();
}
