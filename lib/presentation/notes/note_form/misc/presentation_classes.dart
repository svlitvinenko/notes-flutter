import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kata_note_flutter/domain/core/value_objects.dart';
import 'package:kata_note_flutter/domain/notes/todo_item.dart';
import 'package:kata_note_flutter/domain/notes/value_objects.dart';

part 'presentation_classes.freezed.dart';

@immutable
@freezed
abstract class TodoItemPrimitive implements _$TodoItemPrimitive {
  const TodoItemPrimitive._();

  const factory TodoItemPrimitive({
    @required UniqueId id,
    @required String body,
    @required bool isDone,
  }) = _TodoItemPrimitive;

  factory TodoItemPrimitive.empty() => TodoItemPrimitive(
        id: UniqueId.generate(),
        body: '',
        isDone: false,
      );

  factory TodoItemPrimitive.fromDomain(TodoItem domainItem) => TodoItemPrimitive(
        id: domainItem.id,
        body: domainItem.name.getOrCrash(),
        isDone: domainItem.isDone,
      );

  TodoItem toDomain() => TodoItem(
        id: id,
        name: TodoName(body),
        isDone: isDone,
      );
}
