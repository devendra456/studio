import 'error_handler.dart';

class Failure {
  final int code;
  final String message;

  Failure(this.code, this.message);
}

class DefaultFailure extends Failure {
  DefaultFailure() : super(ResponseCode.default_, ResponseMessage.default_);
}
