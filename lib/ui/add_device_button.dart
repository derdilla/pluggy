import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasmota_plug_control/dev/manager.dart';
import 'package:tasmota_plug_control/ui/add_device_form.dart';
import 'package:tasmota_plug_control/ui/dialog_helper.dart';

class AddDeviceButton extends StatelessWidget {
  const AddDeviceButton({super.key});

  @override
  Widget build(BuildContext context) {
    final staticManager = context.read<Manager>();
    return Padding(
      padding: EdgeInsets.all(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        radius: 40.0,
        onTapDown: (TapDownDetails details) {
          showCustomDialog(
            context,
            details.globalPosition,
            'Add device',
            AddDeviceForm(
              onAddPlug: staticManager.add,
            ),
          );
        },
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Add device'),
            Icon(Icons.add),
          ],
        ),
      ),
    );
  }
}
