import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/collection.dart';
import 'package:notes/app/notes/note_watcher/note_watcher_bloc.dart';
import 'package:notes/domain/notes/note.dart';
import 'package:notes/presentation/notes/notes_overview/widgets/critical_failure_widget.dart';
import 'package:notes/presentation/notes/notes_overview/widgets/empty_notes_widget.dart';
import 'package:notes/presentation/notes/notes_overview/widgets/error_note_card_widget.dart';
import 'package:notes/presentation/notes/notes_overview/widgets/note_card_widget.dart';

class NotesOverviewBodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteWatcherBloc, NoteWatcherState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => Container(),
          loadInProgress: (_) => const Center(child: CircularProgressIndicator()),
          loadSuccess: (state) => _notesBody(context, state.notes),
          loadFailure: (state) => CriticalFailureWidget(failure: state.failure),
        );
      },
    );
  }

  Widget _notesBody(BuildContext context, KtList<Note> notes) {
    return notes.isNotEmpty()
        ? ListView.builder(
            itemBuilder: (context, index) {
              final Note note = notes[index];
              if (note.failureOption.isSome()) {
                return ErrorNoteCardWidget(
                  note: note,
                );
              } else {
                return NoteCardWidget(note: note);
              }
            },
            itemCount: notes.size,
          )
        : const EmptyNotesWidget();
  }
}
