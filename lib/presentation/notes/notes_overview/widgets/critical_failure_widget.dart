import 'package:flutter/material.dart';

import 'package:notes/domain/notes/note_failure.dart';

class CriticalFailureWidget extends StatelessWidget {
  final NoteFailure failure;
  const CriticalFailureWidget({Key key, @required this.failure}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 144,
              color: Theme.of(context).errorColor.withOpacity(0.25),
            ),
            Text(
              'Sorry to let you down',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 64),
            Text(
              failure.map(
                unexpected: (_) => 'Something strange happened.',
                unableToUpdate: (_) => 'We were unable to update your notes.',
                insufficientPermission: (_) => 'It seems the client has no permission to work with notes.',
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 64),
            FlatButton(
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.email),
                  SizedBox(width: 16),
                  Text('Contact us'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
