mixin OnBoardingLocalDataSource{
  Future<List<String>> loadLocalImages();
}

class OnBoardingLocalDataSourceImpl implements OnBoardingLocalDataSource{
  @override
  Future<List<String>> loadLocalImages() {
    // TODO: implement loadLocalImages
    throw UnimplementedError();
  }

}