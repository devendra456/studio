import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:studio/application/constants.dart';
import 'package:studio/application/core/failure.dart';
import 'package:studio/domain/use_cases/load_images_use_case.dart';

import '../../application/core/error_handler.dart';
import '../../application/network/api_base_client.dart';
import '../../application/network/api_routes.dart';

mixin OnBoardingRemoteDataSource {
  Future<Either<Failure, List<String>>> loadRemoteImages(
      LoadImagesParams params);
}

class OnBoardingRemoteDataSourceImpl implements OnBoardingRemoteDataSource {
  @override
  Future<Either<Failure, List<String>>> loadRemoteImages(
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
      print(e);
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
