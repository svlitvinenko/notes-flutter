import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notes/domain/auth/third_party_auth_methods.dart';

part 'auth_method_item.freezed.dart';

@immutable
@freezed
abstract class ThirdPartyAuthMethodPresentationItem with _$ThirdPartyAuthMethodPresentationItem{
  const factory ThirdPartyAuthMethodPresentationItem({
    @required ThirdPartyAuthMethod method,
    @required Widget image,
  }) = _ThirdPartyAuthMethodPresentationItem;
}