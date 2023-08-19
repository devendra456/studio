import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
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
                  title: Text("Share URL"),
                ),
              ),
              PopupMenuItem(
                child: const ListTile(
                  leading: Icon(Icons.share_rounded),
                  title: Text("Share"),
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
}
