import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studio/domain/entities/image_entity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dartz/dartz.dart';
import 'package:studio/application/core/failure.dart';
import 'package:studio/application/core/error_handler.dart';
import 'package:uuid/uuid.dart';

class DownloadService {
  final DefaultCacheManager cacheManager;
  final Dio dio;

  DownloadService({required this.cacheManager, required this.dio});

  /// Downloads an image based on the platform
  /// Returns Either<Failure, String> where String is the path to the downloaded file
  Future<Either<Failure, String>> downloadImage(PageImageData imageEntity) async {
    try {
      // For web platform
      if (kIsWeb) {
        return await _downloadForWeb(imageEntity.url);
      }
      
      // For mobile and desktop platforms
      switch (imageEntity.imageType) {
        case ImageType.local:
          return right(imageEntity.url); // Already a local file
        case ImageType.remote:
          return await _downloadForNative(imageEntity.url);
      }
    } catch (e) {
      return left(Failure(ResponseCode.unknown, 'Failed to download image: ${e.toString()}'));
    }
  }

  /// Downloads image for web platform
  Future<Either<Failure, String>> _downloadForWeb(String url) async {
    try {
      // For web, we use URL launcher to open the image in a new tab
      // which allows the user to save it
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return right(url);
      } else {
        return left(Failure(ResponseCode.unknown, 'Could not launch URL: $url'));
      }
    } catch (e) {
      return left(Failure(ResponseCode.unknown, 'Failed to download image: ${e.toString()}'));
    }
  }

  /// Downloads image for native platforms (mobile and desktop)
  Future<Either<Failure, String>> _downloadForNative(String url) async {
    try {
      // First try to get from cache
      final file = await cacheManager.getSingleFile(url);
      
      // Get the appropriate directory for saving files
      final directory = await _getDownloadDirectory();
      if (directory == null) {
        return left(Failure(ResponseCode.unknown, 'Could not access download directory'));
      }
      
      // Generate a unique filename
      final filename = 'studio_${const Uuid().v4()}.${_getFileExtension(url)}';
      final savePath = '${directory.path}/$filename';
      
      // Copy the file to the download directory
      final bytes = await file.readAsBytes();
      final saveFile = File(savePath);
      await saveFile.writeAsBytes(bytes);
      
      return right(savePath);
    } catch (e) {
      return left(Failure(ResponseCode.unknown, 'Failed to download image: ${e.toString()}'));
    }
  }

  /// Gets the appropriate download directory based on platform
  Future<Directory?> _getDownloadDirectory() async {
    try {
      if (Platform.isAndroid) {
        // For Android, use the downloads directory
        return await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        // For iOS, use the documents directory
        return await getApplicationDocumentsDirectory();
      } else {
        // For desktop platforms
        return await getDownloadsDirectory();
      }
    } catch (e) {
      return null;
    }
  }

  /// Extracts file extension from URL
  String _getFileExtension(String url) {
    final uri = Uri.parse(url);
    final path = uri.path;
    final lastDot = path.lastIndexOf('.');
    
    if (lastDot != -1 && lastDot < path.length - 1) {
      return path.substring(lastDot + 1).toLowerCase();
    }
    
    // Default to jpg if no extension found
    return 'jpg';
  }
}