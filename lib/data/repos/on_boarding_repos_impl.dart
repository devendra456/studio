import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:studio/application/constants.dart';
import 'package:studio/application/core/error_handler.dart';
import 'package:studio/application/network/api_base_client.dart';
import 'package:studio/application/network/api_routes.dart';

import '../../application/core/failure.dart';
import '../../domain/repos/on_boarding_repos.dart';
import '../../domain/use_cases/load_images_use_case.dart';

class OnBoardingReposImpl implements OnBoardingRepos {
  @override
  Future<Either<Failure, List<String>>> getImages(
      LoadImagesParams params) async {
    try {
      final List<String> list = [];
      String urlEndPoint = "/${params.width}/${params.height}?";
      if (params.grayScale == true) {
        urlEndPoint += "grayscale&";
      }
      int? blur = params.blur;
      if (blur != null) {
        if (blur > 0) {
          urlEndPoint += "blur=$blur";
        }
      }
      for (int i = 0; i < kLoadItemPerPage; i++) {
        final res = await ApiBaseClient.client.get(urlEndPoint);
        final url =
            "${APIRoutes.baseURL}/id/${res.headers.map["picsum-id"]?[0]}$urlEndPoint";
        log(url);
        list.add(url);
      }
      return Right(list);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
