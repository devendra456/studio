import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studio/application/core/error_handler.dart';
import 'package:studio/application/core/failure.dart';

mixin OnBoardingLocalDataSource {
  Future<Either<Failure, List<String>>> loadLocalImages();
}

class OnBoardingLocalDataSourceImpl implements OnBoardingLocalDataSource {
  @override
  Future<Either<Failure, List<String>>> loadLocalImages() async {
    try {
      final List<String> list = [];
      final path = await getApplicationCacheDirectory();
      final dir = Directory("${path.path}/libCachedImageData/");
      final fileSystemEntity = dir.listSync();
      for (var element in fileSystemEntity) {
        String oPath = element.path;
        if(oPath.split(".").last.contains('jpg')){
          print(oPath);
          list.add(oPath);
        }
      }
      return Right(list);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
