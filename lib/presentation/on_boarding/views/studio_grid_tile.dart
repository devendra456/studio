import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:studio/domain/entities/image_entity.dart';

class StudioImageTile extends StatelessWidget {
  final PageImageData imageEntity;

  const StudioImageTile({super.key, required this.imageEntity});

  @override
  Widget build(BuildContext context) {
    switch (imageEntity.imageType) {
      case ImageType.local:
        final file = File(imageEntity.url);
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.file(file),
        );
      case ImageType.remote:
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CachedNetworkImage(
            imageUrl: imageEntity.url,
            placeholder: (context, _) {
              return const Icon(Icons.image_outlined, color: Colors.grey);
            },
          ),
        );
    }
  }
}
