import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StudioImageTile extends StatelessWidget {
  final String url;

  const StudioImageTile({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, _) {
        return const Icon(
          Icons.image_outlined,
          color: Colors.grey,
        );
      },
    );
  }
}
