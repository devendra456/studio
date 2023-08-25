import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:studio/application/core/di.dart';
import 'package:studio/application/core/file_helper.dart';
import 'package:studio/presentation/on_boarding/views/studio_grid_tile.dart';

class ImageViewerScreen extends StatelessWidget {
  final String url;

  const ImageViewerScreen({super.key, required this.url});

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
                child: const ListTile(
                  leading: Icon(Icons.link_rounded),
                  title: Text("Share Link"),
                ),
              ),
              PopupMenuItem(
                child: const ListTile(
                  leading: Icon(Icons.copy_rounded),
                  title: Text("Copy Link"),
                ),
                onTap: () {},
              ),
              PopupMenuItem(
                child: const ListTile(
                  leading: Icon(Icons.share_rounded),
                  title: Text("Share File"),
                ),
                onTap: () async {
                  var file = await DefaultCacheManager().getSingleFile(url);
                  Share.shareXFiles([XFile(file.path)]);
                },
              ),
              PopupMenuItem(
                child: const ListTile(
                  leading: Icon(Icons.file_copy_rounded),
                  title: Text("Copy File"),
                ),
                onTap: () {},
              ),
              PopupMenuItem(
                child: const ListTile(
                  leading: Icon(Icons.download_rounded),
                  title: Text("Download"),
                ),
                onTap: () {
                  DefaultCacheManager();
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
