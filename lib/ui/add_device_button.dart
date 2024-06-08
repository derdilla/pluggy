import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasmota_plug_control/dev/manager.dart';
import 'package:tasmota_plug_control/ui/add_device_form.dart';

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
          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: 'Add device',
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              final x = ((details.globalPosition.dx * 2)
                  / MediaQuery.of(context).size.width)
                - 1.0;
              final y = ((details.globalPosition.dy * 2)
                  / MediaQuery.of(context).size.height)
                - 1.0;
              return AlignTransition(
                alignment: Tween<AlignmentGeometry>(
                  begin: Alignment(x, y),
                  end: Alignment.center,
                ).animate(animation),
                child: ScaleTransition(
                  scale: animation,
                  child: Material(
                    child: Card(
                      child: AddDeviceForm(
                        onAddPlug: staticManager.add,
                      ),
                    ),
                  ),
                ),
              );
            },
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
