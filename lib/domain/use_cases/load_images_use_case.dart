import 'package:dartz/dartz.dart';
import 'package:studio/application/core/failure.dart';
import 'package:studio/application/core/use_case.dart';
import 'package:studio/domain/repos/on_boarding_repos.dart';

class LoadImagesUseCase implements UseCase<List<String>, LoadImagesParams> {
  final OnBoardingRepos _boardingRepos;

  LoadImagesUseCase(this._boardingRepos);

  @override
  Future<Either<Failure, List<String>>> call(LoadImagesParams params) async {
    return await _boardingRepos.getImages(params);
  }
}

class LoadImagesParams {
  final int height;
  final int width;
  final bool? grayScale;
  final int? blur;

  LoadImagesParams({
    required this.height,
    required this.width,
    this.grayScale,
    this.blur,
  });
}
