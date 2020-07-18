import 'package:auto_route/auto_route.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/app/auth/auth_bloc.dart';
import 'package:notes/app/notes/note_actor/note_actor_bloc.dart';
import 'package:notes/app/notes/note_watcher/note_watcher_bloc.dart';
import 'package:notes/injection.dart';
import 'package:notes/presentation/notes/notes_overview/widgets/notes_overview_body_widget.dart';
import 'package:notes/presentation/routes/router.gr.dart';

class NotesOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteWatcherBloc>(
          create: (_) => getIt<NoteWatcherBloc>()..add(const NoteWatcherEvent.watchAllStarted()),
        ),
        BlocProvider<NoteActorBloc>(
          create: (_) => getIt<NoteActorBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              state.maybeMap(
                unauthenticated: (_) => ExtendedNavigator.of(context).pushReplacementNamed(Routes.signInPage),
                orElse: () {},
              );
            },
          ),
          BlocListener<NoteActorBloc, NoteActorState>(
            listener: (context, state) {
              state.maybeMap(
                deleteFailure: (state) {
                  FlushbarHelper.createError(
                    message: state.failure.map(
                      unexpected: (_) => 'Could not delete the note',
                      unableToUpdate: (_) => 'Note could not be updated',
                      insufficientPermission: (_) => 'Permission denied',
                    ),
                  ).show(context);
                },
                deleteSuccess: (_) {
                  FlushbarHelper.createSuccess(message: 'Note was deleted successfully').show(context);
                },
                orElse: () {},
              );
            },
          )
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Notes'),
            leading: IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                context.bloc<AuthBloc>().add(const AuthEvent.signedOut());
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.indeterminate_check_box),
                onPressed: () {},
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {},
            label: Row(
              children: [
                const Icon(Icons.add),
                const SizedBox(
                  width: 16,
                ),
                const Text('ADD NOTE'),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: NotesOverviewBodyWidget(),
        ),
      ),
    );
  }
}
