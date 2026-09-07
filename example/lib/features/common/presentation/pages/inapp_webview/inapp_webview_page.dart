import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/fp_core.dart' hide InAppWebViewPage;

@RoutePage()
class InAppWebViewPage extends StatelessWidget {
  final String initialUrl;
  final String? title;

  const InAppWebViewPage({super.key, required this.initialUrl, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title ?? 'Web View'), centerTitle: true),
      body: InAppWebViewContainer(initialUrl: initialUrl, title: title),
    );
  }
}
