import 'package:flutter/material.dart';
import 'package:tasmota_plug_control/dev/plug.dart';

class AddDeviceForm extends StatefulWidget {
  const AddDeviceForm({super.key, required this.onAddPlug});

  final void Function(Plug plug) onAddPlug;

  @override
  State<AddDeviceForm> createState() => _AddDeviceFormState();
}

class _AddDeviceFormState extends State<AddDeviceForm> {
  final _controller = TextEditingController();

  String? _error;

  bool _validating = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Plug'),
      content: TextField(
        autofocus: true,
        controller: _controller,
        onSubmitted: (_) => _onFormSubmit(),
        decoration: InputDecoration(
          labelText: 'Address',
          hintText: '127.0.0.1',
          errorText: _error,
          border: const OutlineInputBorder(),
          suffix: _validating ? CircularProgressIndicator() : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.add),
          label: Text('Add'),
          onPressed: _onFormSubmit,
        )
      ],
    );
  }

  void _onFormSubmit() async {
    setState(() {
      _validating = true;
    });
    final plug = Plug(_controller.text);
    if ((await plug.updateStatus()).active) {
      widget.onAddPlug(plug);
      Navigator.pop(context);
    } else {
      setState(() {
        _error = 'The plug needs to be enabled and reachable to add.';
        _validating = false;
      });
    }

  }
}
