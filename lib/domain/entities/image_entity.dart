class ImageEntity {
  final List<String> url;
  final ImageType imageType;

  ImageEntity({required this.url, required this.imageType});
}

class PageImageData {
  final String url;
  final ImageType imageType;

  PageImageData(this.url, this.imageType);
}

enum ImageType {
  local,
  remote,
}
