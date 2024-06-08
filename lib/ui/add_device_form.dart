import 'package:flutter/material.dart';
import 'package:tasmota_plug_controll/dev/plug.dart';

class AddDeviceForm extends StatefulWidget {
  const AddDeviceForm({super.key, required this.onAddPlug});

  final void Function(Plug plug) onAddPlug;

  @override
  State<AddDeviceForm> createState() => _AddDeviceFormState();
}

class _AddDeviceFormState extends State<AddDeviceForm> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        autofocus: true,
        controller: controller,
        onSubmitted: (_) => _onFormSubmit(),
        decoration: InputDecoration(
          labelText: 'Address',
          hintText: '127.0.0.1',
          border: const OutlineInputBorder(),
          suffix: IconButton(
            icon: const Icon(Icons.add),
            onPressed: _onFormSubmit, // TODO: validation
          ),
        ),
      ),
    );
  }

  void _onFormSubmit() {
    final plug = Plug(controller.text);
    widget.onAddPlug(plug);
    Navigator.pop(context);
  }
}
