import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:share_plus/share_plus.dart';
import 'package:studio/application/core/show_message.dart';
import 'package:studio/presentation/on_boarding/views/studio_grid_tile.dart';

class ImageViewerScreen extends StatelessWidget {
  final String url;

  ImageViewerScreen({super.key, required this.url});

  final DefaultCacheManager defaultCacheManager = DefaultCacheManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  Share.share(url, subject: url);
                },
                child: ListTile(
                  leading: const Icon(Icons.link_rounded),
                  title: Text(
                    "Share Link",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.copy_rounded),
                  title: Text(
                    "Copy Link",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(text: url),
                  );
                  ShowMessage.show(context, "Copied to Clipboard");
                },
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.share_rounded),
                  title: Text(
                    "Share File",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                onTap: () async {
                  var file = await defaultCacheManager.getSingleFile(url);
                  Share.shareXFiles([XFile(file.path)]);
                },
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.file_copy_rounded),
                  title: Text(
                    "Copy File",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                onTap: () async {
                  var file = await defaultCacheManager.getSingleFile(url);
                  final fileString = await file.readAsString();
                  final data = base64Decode(fileString);
                  Pasteboard.writeImage(data);
                  if (!context.mounted) return;
                  ShowMessage.show(context, "File copied to clipboard");
                },
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.download_rounded),
                  title: Text(
                    "Download",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                onTap: () {
                  defaultCacheManager.getSingleFile(url);
                },
              ),
            ];
          }),
        ],
      ),
      body: InteractiveViewer(
        child: Center(
          child: Hero(
            tag: url,
            child: StudioImageTile(
              url: url,
            ),
          ),
        ),
      ),
    );
  }
}
