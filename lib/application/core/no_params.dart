import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'no_params.freezed.dart';
part 'no_params.g.dart';

NoParams noParamsFromJson(String str) => NoParams.fromJson(json.decode(str));

String noParamsToJson(NoParams data) => json.encode(data.toJson());

@freezed
class NoParams with _$NoParams {
  const factory NoParams() = _NoParams;

  factory NoParams.fromJson(Map<String, dynamic> json) =>
      _$NoParamsFromJson(json);
}
