import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../locator.dart';
import '../../../../shared/widgets/wrappers.dart';

/// Presents the Media Engine feature.
///
/// Clean Architecture **presentation** layer.
class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  String? _pickedImagePath;
  String? _pickNote;
  bool _isPlaying = false;

  static const _demoMp3 =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  Future<void> _pickAndCompress() async {
    final file = await ImageHelper.pickAndCompress(ImageSource.gallery);
    if (file == null || !mounted) return;
    setState(() {
      _pickedImagePath = file.path;
      _pickNote = 'Compressed image size: ${file.lengthSync()} bytes';
    });
  }

  Future<void> _toggleAudio() async {
    final service = getIt<AudioPlayerService>();
    if (_isPlaying) {
      await service.pause();
    } else {
      await service.playUrl(_demoMp3);
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  Future<void> _stopAudio() async {
    final service = getIt<AudioPlayerService>();
    await service.stop();
    await service.seek(Duration.zero);
    setState(() => _isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Media Engine',
      child: Column(
        children: [
          DemoCard(
            title: 'Image Picker & Compression',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_pickedImagePath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_pickedImagePath!),
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (_pickNote != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _pickNote!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _pickAndCompress,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Pick & compress image'),
                ),
              ],
            ),
          ),
          DemoCard(
            title: 'Audio Player',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: _toggleAudio,
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    ),
                    IconButton(
                      onPressed: _stopAudio,
                      icon: const Icon(Icons.stop),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isPlaying ? 'Playing demo stream…' : 'Paused',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                Text(
                  'AudioPlayerService is a singleton; listen to '
                  'player.onPositionChanged / onDurationChanged to build UI.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          DemoCard(
            title: 'PDF Viewer',
            child: Text(
              "Use PrakashPdfViewer(filePath: '/path/to/file.pdf') when you "
              'have a real PDF path at runtime.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}