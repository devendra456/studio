import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:studio/application/core/failure.dart';
import 'package:studio/application/network/network_info.dart';
import 'package:studio/application/preferences/app_preferences.dart';
import 'package:studio/application/preferences/app_preferences_keys.dart';
import 'package:studio/domain/entities/image_entity.dart';
import 'package:studio/domain/use_cases/load_images_use_case.dart';

import '../../../application/constants.dart';

part 'on_boarding_bloc.freezed.dart';

part 'on_boarding_event.dart';

part 'on_boarding_state.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  final LoadImagesUseCase _loadImagesUseCase;
  final AppPreferences _appPreferences;
  final NetworkInfo _networkInfo;
  final PagingController<int, PageImageData> pagingController =
      PagingController(firstPageKey: 0);

  OnBoardingBloc(
      this._loadImagesUseCase, this._appPreferences, this._networkInfo)
      : super(const OnBoardingState.initial()) {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _networkInfo.connectivitySubscription().listen((event) async {
      if (await _networkInfo.isConnected()) {
        pagingController.refresh();
      }
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    final int height =
        _appPreferences.getInt(AppPreferencesKeys.height) ?? kInitialHeight;
    final int width =
        _appPreferences.getInt(AppPreferencesKeys.width) ?? kInitialWidth;
    final int? blur =
        _appPreferences.getDouble(AppPreferencesKeys.blur)?.toInt();
    final bool? grayScale =
        _appPreferences.getBool(AppPreferencesKeys.grayScale);
    final res = await _loadImagesUseCase.call(
      LoadImagesParams(
        height: height,
        width: width,
        blur: blur,
        grayScale: grayScale,
      ),
    );
    res.fold(_imageLoadFailed, _imageLoadSuccess);
  }

  Future<void> onPageRefresh() async {
    pagingController.refresh();
  }

  _imageLoadFailed(Failure l) {
    pagingController.error = l.message;
  }

  _imageLoadSuccess(ImageEntity r) {
    final list = r.url.map((e) => PageImageData(e, r.imageType)).toList();
    switch (r.imageType) {
      case ImageType.local:
        pagingController.appendLastPage(list);
      case ImageType.remote:
        pagingController.appendPage(list, list.length);
    }
  }
}
