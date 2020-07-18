import 'package:flutter/material.dart';

import 'package:notes/domain/notes/note.dart';

class ErrorNoteCardWidget extends StatelessWidget {
  final Note note;

  const ErrorNoteCardWidget({Key key, @required this.note}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).errorColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.error,
                  color: Theme.of(context).cardColor,
                ),
                const SizedBox(width: 16),
                Text(
                  'Ooops!',
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Theme.of(context).cardColor,
                      ),
                ),
              ],
            ),
            Divider(
              color: Theme.of(context).cardColor,
            ),
            Text(
              "There's a problem with this note. Still, you can get it. Please, tap this card to contact the support.",
              style: Theme.of(context).textTheme.subtitle1.copyWith(color: Theme.of(context).cardColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Info for nerds: ${note.failureOption.fold(() => '', (a) => a.toString())}',
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: Theme.of(context).cardColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
