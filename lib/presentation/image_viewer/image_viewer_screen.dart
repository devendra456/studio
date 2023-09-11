import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:studio/application/core/show_message.dart';
import 'package:studio/domain/entities/image_entity.dart';
import 'package:studio/presentation/on_boarding/views/studio_grid_tile.dart';

class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen({
    super.key,
    required this.imageEntity,
    required this.defaultCacheManager,
  });

  final DefaultCacheManager defaultCacheManager;
  final PageImageData imageEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  switch (imageEntity.imageType) {
                    case ImageType.local:
                    case ImageType.remote:
                      Share.share(
                        imageEntity.url,
                        subject: imageEntity.url,
                      );
                  }
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
                  switch (imageEntity.imageType) {
                    case ImageType.local:
                    case ImageType.remote:
                      Clipboard.setData(
                        ClipboardData(text: imageEntity.url),
                      );
                      ShowMessage.show(context, "Copied to Clipboard");
                  }
                },
              ),
              if (!kIsWeb)
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.share_rounded),
                    title: Text(
                      "Share File",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  onTap: () async {
                    switch (imageEntity.imageType) {
                      case ImageType.local:
                        Share.shareXFiles([XFile(imageEntity.url)]);
                      case ImageType.remote:
                        var file = await defaultCacheManager
                            .getSingleFile(imageEntity.url);
                        Share.shareXFiles([XFile(file.path)]);
                    }
                  },
                ),
              /*PopupMenuItem(
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
              ),*/
            ];
          }),
        ],
      ),
      body: InteractiveViewer(
        child: Center(
          child: Hero(
            tag: imageEntity.url,
            child: StudioImageTile(
              imageEntity: imageEntity,
            ),
          ),
        ),
      ),
    );
  }
}
