import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notes/domain/core/value_objects.dart';
import 'package:notes/domain/notes/note.dart';
import 'package:notes/domain/notes/todo_item.dart';
import 'package:notes/domain/notes/value_objects.dart';
import 'package:kt_dart/kt.dart';

part 'note_dtos.freezed.dart';
part 'note_dtos.g.dart';

@immutable
@freezed
abstract class NoteDto implements _$NoteDto {
  const NoteDto._();

  const factory NoteDto({
    @JsonKey(ignore: true) String id,
    @required String body,
    @required int color,
    @required List<TodoItemDto> todos,
    @required @ServerTimestampConverter() FieldValue serverTimeStamp,
  }) = _NoteDto;

  factory NoteDto.fromDomain(Note domainItem) => NoteDto(
        id: domainItem.id.getOrCrash(),
        body: domainItem.body.getOrCrash(),
        color: domainItem.color.getOrCrash().value,
        todos: domainItem.todos.getOrCrash().asList().map((i) => TodoItemDto.fromDomain(i)).toList(),
        serverTimeStamp: FieldValue.serverTimestamp(),
      );

  Note toDomain() => Note(
        id: UniqueId.fromUniqueString(id),
        body: NoteBody(body),
        color: NoteColor(Color(color)),
        todos: List3(KtList.from(todos.map((e) => e.toDomain()))),
      );

  factory NoteDto.fromJson(Map<String, dynamic> json) => _$NoteDtoFromJson(json);

  factory NoteDto.fromFirestore(DocumentSnapshot document) {
    return NoteDto.fromJson(document.data).copyWith(id: document.documentID);
  }
}

class ServerTimestampConverter implements JsonConverter<FieldValue, Object> {
  const ServerTimestampConverter();

  @override
  FieldValue fromJson(Object json) {
    return FieldValue.serverTimestamp();
  }

  @override
  Object toJson(FieldValue fieldValue) {
    return fieldValue;
  }
}

@immutable
@freezed
abstract class TodoItemDto implements _$TodoItemDto {
  const TodoItemDto._();

  const factory TodoItemDto({
    @required String id,
    @required String name,
    @required bool isDone,
  }) = _TodoItemDto;

  factory TodoItemDto.fromDomain(TodoItem domainItem) => TodoItemDto(
        id: domainItem.id.getOrCrash(),
        name: domainItem.name.getOrCrash(),
        isDone: domainItem.isDone,
      );

  TodoItem toDomain() => TodoItem(
        id: UniqueId.fromUniqueString(id),
        name: TodoName(name),
        isDone: isDone,
      );

  factory TodoItemDto.fromJson(Map<String, dynamic> json) => _$TodoItemDtoFromJson(json);
}
