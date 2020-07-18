import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/kt.dart';
import 'package:notes/app/notes/note_actor/note_actor_bloc.dart';
import 'package:notes/domain/notes/note.dart';
import 'package:notes/presentation/notes/notes_overview/widgets/todo_item_widget.dart';

class NoteCardWidget extends StatelessWidget {
  final Note note;

  const NoteCardWidget({Key key, @required this.note}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.color.getOrCrash(),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to Single Note Page
        },
        onLongPress: () {
          final noteActorBloc = context.bloc<NoteActorBloc>();
          _showDeletionDialog(context, noteActorBloc);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                note.body.getOrCrash(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              if (note.todos.length > 0) ...[
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 16,
                  children: [
                    ...note.todos
                        .getOrCrash()
                        .map(
                          (todoItem) => TodoItemWidget(todoItem: todoItem),
                        )
                        .iter,
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDeletionDialog(BuildContext context, NoteActorBloc bloc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete note?'),
        content: Text(
          note.body.getOrCrash(),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FlatButton(
            onPressed: () {
              bloc.add(NoteActorEvent.deleted(note));
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
