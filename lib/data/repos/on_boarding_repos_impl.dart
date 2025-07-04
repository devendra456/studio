import 'package:dartz/dartz.dart';
import 'package:studio/application/network/network_info.dart';
import 'package:studio/data/data_source/on_boarding_local_data_source.dart';
import 'package:studio/data/data_source/on_boarding_remote_data_source.dart';
import 'package:studio/domain/entities/image_entity.dart';

import '../../application/core/failure.dart';
import '../../domain/repos/on_boarding_repos.dart';
import '../../domain/use_cases/load_images_use_case.dart';

class OnBoardingReposImpl implements OnBoardingRepos {
  final OnBoardingRemoteDataSource onBoardingRemoteDataSource;
  final OnBoardingLocalDataSource onBoardingLocalDataSource;
  final NetworkInfo networkInfo;

  OnBoardingReposImpl({
    required this.onBoardingRemoteDataSource,
    required this.onBoardingLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ImageEntity>> getImages(
      LoadImagesParams params) async {
    final isConnected = await networkInfo.isConnected();
    if (isConnected) {
      final res = await onBoardingRemoteDataSource.loadRemoteImages(params);
      return res.fold((l) => Left(l), (r) {
        return Right(ImageEntity(url: r,imageType: ImageType.remote));
      });
    } else {
      final res = await onBoardingLocalDataSource.loadLocalImages();
      return res.fold((l) => Left(l), (r) {
        return Right(ImageEntity(url: r,imageType: ImageType.local));
      });
    }
  }
}
