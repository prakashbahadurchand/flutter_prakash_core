import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/flutter_prakash_core.dart'
    hide FilePreviewPage;

@RoutePage()
class FilePreviewPage extends StatelessWidget {
  final String filePath;
  final FileType fileType;
  final FileSourceType sourceType;
  final String? title;

  const FilePreviewPage({
    super.key,
    required this.filePath,
    required this.fileType,
    this.sourceType = FileSourceType.network,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? (fileType == FileType.pdf ? 'PDF Preview' : 'Image Preview')),
        centerTitle: true,
      ),
      body: FilePreviewContainer(
        filePath: filePath,
        fileType: fileType,
        sourceType: sourceType,
        title: title,
      ),
    );
  }
}
