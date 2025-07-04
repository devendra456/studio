import 'package:dio/dio.dart';

import 'failure.dart';

enum DataSource {
  success,
  noContent,
  badRequest,
  forbidden,
  unAuthorised,
  notFound,
  internalServerError,
  connectionTimeOut,
  cancel,
  receiveTimeOut,
  sendTimeOut,
  cacheError,
  noInternetConnection,
  badCertificate,
  badResponse,
  connectionError,
  unknown,
  default_
}

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioError) {
      failure = _handleError(error);
    } else {
      failure = DataSource.default_.getFailure();
    }
  }

  Failure _handleError(DioError error) {
    switch (error.type) {
      case DioErrorType.sendTimeout:
        return DataSource.sendTimeOut.getFailure();
      case DioErrorType.receiveTimeout:
        return DataSource.receiveTimeOut.getFailure();
      case DioErrorType.cancel:
        return DataSource.cancel.getFailure();
      case DioErrorType.connectionTimeout:
        return DataSource.connectionTimeOut.getFailure();
      case DioErrorType.badCertificate:
        return DataSource.badCertificate.getFailure();
      case DioErrorType.badResponse:
        final code = error.response?.statusCode;
        switch (code) {
          case ResponseCode.internalServerError:
            return DataSource.internalServerError.getFailure();
          case ResponseCode.badRequest:
            return DataSource.badRequest.getFailure();
          case ResponseCode.unknown:
            return DataSource.unknown.getFailure();
          case ResponseCode.badCertificate:
            return DataSource.badCertificate.getFailure();
          case ResponseCode.notFound:
            return DataSource.notFound.getFailure();
          case ResponseCode.unAuthorised:
            return DataSource.unAuthorised.getFailure();
          case ResponseCode.forbidden:
            return DataSource.forbidden.getFailure();
          case ResponseCode.noContent:
            return DataSource.noContent.getFailure();
          case ResponseCode.success:
            return DataSource.success.getFailure();
          default:
            return DataSource.internalServerError.getFailure();
        }
      case DioErrorType.connectionError:
        return DataSource.connectionError.getFailure();
      case DioErrorType.unknown:
        return DataSource.unknown.getFailure();
    }
  }
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.badRequest:
        return Failure(ResponseCode.badRequest, ResponseMessage.badRequest);
      case DataSource.forbidden:
        return Failure(ResponseCode.forbidden, ResponseMessage.forbidden);
      case DataSource.unAuthorised:
        return Failure(ResponseCode.unAuthorised, ResponseMessage.unAuthorised);
      case DataSource.notFound:
        return Failure(ResponseCode.notFound, ResponseMessage.notFound);
      case DataSource.internalServerError:
        return Failure(ResponseCode.internalServerError,
            ResponseMessage.internalServerError);
      case DataSource.connectionTimeOut:
        return Failure(
            ResponseCode.connectionTimeOut, ResponseMessage.connectionTimeOut);
      case DataSource.cancel:
        return Failure(ResponseCode.cancel, ResponseMessage.cancel);
      case DataSource.receiveTimeOut:
        return Failure(
            ResponseCode.receiveTimeOut, ResponseMessage.receiveTimeOut);
      case DataSource.sendTimeOut:
        return Failure(ResponseCode.sendTimeOut, ResponseMessage.sendTimeOut);
      case DataSource.cacheError:
        return Failure(ResponseCode.cacheError, ResponseMessage.cacheError);
      case DataSource.noInternetConnection:
        return Failure(ResponseCode.noInternetConnection,
            ResponseMessage.noInternetConnection);
      case DataSource.default_:
        return Failure(ResponseCode.default_, ResponseMessage.default_);
      case DataSource.success:
        return Failure(ResponseCode.success, ResponseMessage.success);
      case DataSource.noContent:
        return Failure(ResponseCode.noContent, ResponseMessage.noContent);
      case DataSource.badCertificate:
        return Failure(
            ResponseCode.badCertificate, ResponseMessage.badCertificate);
      case DataSource.badResponse:
        return Failure(ResponseCode.badResponse, ResponseMessage.badResponse);
      case DataSource.connectionError:
        return Failure(
            ResponseCode.connectionError, ResponseMessage.connectionError);
      case DataSource.unknown:
        return Failure(ResponseCode.unknown, ResponseMessage.unknown);
    }
  }
}

class ResponseCode {
  // API status codes
  static const int success = 200; // success with data
  static const int noContent = 201; // success with no content
  static const int badRequest = 400; // failure, api rejected the request
  static const int forbidden = 403; // failure, api rejected the request
  static const int unAuthorised = 401; // failure user is not authorised
  static const int notFound = 404;
  static const int internalServerError = 500;
  static const int default_ = -1;
  static const int connectionTimeOut = -2;
  static const int cancel = -3;
  static const int receiveTimeOut = -4;
  static const int sendTimeOut = -5;
  static const int cacheError = -6;
  static const int noInternetConnection = -7;
  static const int badCertificate = 495;
  static const int badResponse = -9;
  static const int connectionError = -8;
  static const int unknown = 520;
}

class ResponseMessage {
  static const String success = "Success";
  static const String noContent = "No Content";
  static const String badRequest = "Bad Request";
  static const String forbidden = "Forbidden";
  static const String unAuthorised = "UnAuthorised";
  static const String notFound = "Not Found";
  static const String internalServerError = "Internal Server Error";

  static const String default_ = "Something went wrong";
  static const String connectionTimeOut = "Connection time out";
  static const String cancel = "Canceled";
  static const String receiveTimeOut = "Receive time out";
  static const String sendTimeOut = "Send time out";
  static const String cacheError = "Cache error";
  static const String noInternetConnection = "No Internet Connection";

  static const String unknown = "Unknown";
  static const String connectionError = "Connection Error";
  static const String badResponse = "Bad Response";
  static const String badCertificate = "Bad Certificate";
}
