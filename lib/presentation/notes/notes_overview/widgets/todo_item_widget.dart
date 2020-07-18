import 'package:flutter/material.dart';

import 'package:notes/domain/notes/todo_item.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoItem todoItem;

  const TodoItemWidget({Key key, @required this.todoItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (todoItem.isDone) ...[
          Icon(
            Icons.check_box,
            color: Theme.of(context).accentColor,
          ),
        ] else ...[
          Icon(
            Icons.check_box_outline_blank,
            color: Theme.of(context).accentColor,
          ),
        ],
        const SizedBox(
          width: 4,
        ),
        Text(todoItem.name.getOrCrash()),
      ],
    );
  }
}
