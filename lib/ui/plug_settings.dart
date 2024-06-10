import 'package:flutter/material.dart';

class PlugSettings extends StatelessWidget {
  const PlugSettings({
    required this.delete,
  });

  final void Function() delete;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text('Delete plug'),
    content: Text('Do you want to delete the plug?'),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Cancel')
      ),
      ElevatedButton.icon(
        onPressed: () {
          delete();
          Navigator.pop(context);
        },
        icon: Icon(Icons.delete_forever),
        label: Text('Delete'),
      )
    ],
  );

}