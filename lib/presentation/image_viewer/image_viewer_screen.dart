import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:studio/application/core/di.dart';
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
                onTap: () async{
                  final res = await getIt.get<Dio>().get(url);
                  Share.shareXFiles([]);
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
                onTap: () {},
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

  Future<void> _saveImage(BuildContext context) async {
    String? message;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // Download image
      final http.Response response = await http.get(Uri.parse(_url));

      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename = '${dir.path}/image.png';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        message = 'Image saved to disk';
      }
    } catch (e) {
      message = 'An error occurred while saving the image';
    }

    if (message != null) {
      scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }


}
