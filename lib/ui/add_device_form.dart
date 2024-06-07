import 'package:flutter/material.dart';

class AddDeviceForm extends StatelessWidget {
  const AddDeviceForm({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement logic
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Address',
          hintText: '127.0.0.1',
          border: const OutlineInputBorder(),
          suffix: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {}, // TODO: disable when not valid
          ),
        ),
      ),
    );
  }
}
