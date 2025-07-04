import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:studio/application/core/di.dart';
import 'package:studio/application/core/show_message.dart';
import 'package:studio/application/download/download_service.dart';
import 'package:studio/application/favorites/favorites_service.dart';
import 'package:studio/domain/entities/image_entity.dart';
import 'package:studio/presentation/on_boarding/views/studio_grid_tile.dart';

class ImageViewerScreen extends StatefulWidget {
  const ImageViewerScreen({
    super.key,
    required this.imageEntity,
    required this.defaultCacheManager,
  });

  final DefaultCacheManager defaultCacheManager;
  final PageImageData imageEntity;

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  final FavoritesService _favoritesService = getIt.get<FavoritesService>();
  final DownloadService _downloadService = getIt.get<DownloadService>();
  bool _isFavorite = false;
  bool _isCheckingFavorite = true;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    if (!_favoritesService.isUserLoggedIn) {
      setState(() {
        _isCheckingFavorite = false;
        _isFavorite = false;
      });
      return;
    }

    final result = await _favoritesService.isImageFavorite(
      widget.imageEntity.url,
    );

    result.fold(
      (failure) {
        setState(() {
          _isCheckingFavorite = false;
          _isFavorite = false;
        });
      },
      (isFavorite) {
        setState(() {
          _isCheckingFavorite = false;
          _isFavorite = isFavorite;
        });
      },
    );
  }

  Future<void> _toggleFavorite() async {
    if (!_favoritesService.isUserLoggedIn) {
      ShowMessage.show(context, "Please login to add favorites");
      return;
    }

    setState(() {
      _isCheckingFavorite = true;
    });

    if (_isFavorite) {
      // Remove from favorites
      final result = await _favoritesService.removeFromFavorites(
        widget.imageEntity.url,
      );

      result.fold(
        (failure) {
          ShowMessage.show(context, failure.message);
          setState(() {
            _isCheckingFavorite = false;
          });
        },
        (success) {
          setState(() {
            _isFavorite = false;
            _isCheckingFavorite = false;
          });
          ShowMessage.show(context, "Removed from favorites");
        },
      );
    } else {
      // Add to favorites
      final result = await _favoritesService.addToFavorites(widget.imageEntity);

      result.fold(
        (failure) {
          ShowMessage.show(context, failure.message);
          setState(() {
            _isCheckingFavorite = false;
          });
        },
        (favoriteEntity) {
          setState(() {
            _isFavorite = true;
            _isCheckingFavorite = false;
          });
          ShowMessage.show(context, "Added to favorites");
        },
      );
    }
  }

  /// Downloads the current image
  Future<void> _downloadImage() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    final result = await _downloadService.downloadImage(widget.imageEntity);

    setState(() {
      _isDownloading = false;
    });

    if (!mounted) return;

    result.fold(
      (failure) {
        ShowMessage.show(context, failure.message);
      },
      (filePath) {
        ShowMessage.show(context, "Image downloaded successfully");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Favorite button
          _isCheckingFavorite
              ? const SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : null,
                  ),
                  onPressed: _toggleFavorite,
                ),
          // Menu button
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () {
                    switch (widget.imageEntity.imageType) {
                      case ImageType.local:
                      case ImageType.remote:
                        SharePlus.instance.share(
                          ShareParams(
                            text: widget.imageEntity.url,
                            subject: widget.imageEntity.url,
                          ),
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
                    switch (widget.imageEntity.imageType) {
                      case ImageType.local:
                      case ImageType.remote:
                        Clipboard.setData(
                          ClipboardData(text: widget.imageEntity.url),
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
                      switch (widget.imageEntity.imageType) {
                        case ImageType.local:
                          SharePlus.instance.share(
                            ShareParams(
                              downloadFallbackEnabled: true,
                              files: [XFile(widget.imageEntity.url)],
                            ),
                          );
                        case ImageType.remote:
                          var file = await widget.defaultCacheManager
                              .getSingleFile(widget.imageEntity.url);
                          SharePlus.instance.share(
                            ShareParams(
                              downloadFallbackEnabled: true,
                              files: [XFile(file.path)],
                            ),
                          );
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
              ),*/
                PopupMenuItem(
                  onTap: _downloadImage,
                  child: ListTile(
                    leading: const Icon(Icons.download_rounded),
                    title: Text(
                      "Download",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: InteractiveViewer(
        child: Center(
          child: Hero(
            tag: widget.imageEntity.url,
            child: StudioImageTile(imageEntity: widget.imageEntity),
          ),
        ),
      ),
    );
  }
}
