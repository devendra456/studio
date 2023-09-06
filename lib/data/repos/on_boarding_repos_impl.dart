import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:studio/application/core/error_handler.dart';
import 'package:studio/application/network/api_base_client.dart';

import '../../application/core/failure.dart';
import '../../domain/repos/on_boarding_repos.dart';
import '../../domain/use_cases/load_images_use_case.dart';

class OnBoardingReposImpl implements OnBoardingRepos {
  int i = 0;

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
      final res = await ApiBaseClient.client.get(urlEndPoint);
      final realURI = res.realUri;
      String url = "${realURI.scheme}://${realURI.host}${realURI.path}?";
      realURI.queryParametersAll.forEach((key, value) {
        url += "$key=${value[0]}&";
      });
      if (kIsWeb) {
        url += "${i++}";
      }
      list.add(url);
      return Right(list);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
