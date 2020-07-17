import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kata_note_flutter/domain/core/failures.dart';
import 'package:kata_note_flutter/domain/core/value_objects.dart';
import 'package:kata_note_flutter/domain/notes/value_objects.dart';

part 'todo_item.freezed.dart';

@immutable
@freezed
abstract class TodoItem implements _$TodoItem {
  const TodoItem._();

  const factory TodoItem({
    @required UniqueId id,
    @required TodoName name,
    @required bool isDone,
  }) = _TodoItem;

  factory TodoItem.empty() => TodoItem(
        id: UniqueId.generate(),
        name: TodoName(''),
        isDone: false,
      );

  /// Опция с возможной ошибкой.
  Option<ValueFailure<dynamic>> get failureOption {
    return name.value.fold(some, (_) => none());
  }
}
