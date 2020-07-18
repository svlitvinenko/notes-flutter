import 'package:freezed_annotation/freezed_annotation.dart';

part 'third_party_auth_methods.freezed.dart';

@immutable
@freezed
abstract class ThirdPartyAuthMethod with _$ThirdPartyAuthMethod {
  const factory ThirdPartyAuthMethod.google() = Google;
  const factory ThirdPartyAuthMethod.apple() = Apple;
}
