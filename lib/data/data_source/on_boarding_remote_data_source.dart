mixin OnBoardingRemoteDataSource {
  Future<List<String>> loadRemoteImages();
}

class OnBoardingRemoteDataSourceImpl implements OnBoardingRemoteDataSource {
  @override
  Future<List<String>> loadRemoteImages() async {
    // TODO: implement loadRemoteImages
    throw UnimplementedError();
  }
}
