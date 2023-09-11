import 'package:dartz/dartz.dart';
import 'package:studio/application/core/failure.dart';
import 'package:studio/domain/entities/image_entity.dart';
import 'package:studio/domain/use_cases/load_images_use_case.dart';

mixin OnBoardingRepos {
  Future<Either<Failure, ImageEntity>> getImages(LoadImagesParams params);
}
