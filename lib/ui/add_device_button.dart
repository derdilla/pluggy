import 'package:flutter/material.dart';
import 'package:transmota_plug_controll/ui/add_device_form.dart';

class AddDeviceButton extends StatelessWidget {
  const AddDeviceButton({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement logic
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
              print(x);
              print(y);
              return AlignTransition(
                alignment: Tween<AlignmentGeometry>(
                  begin: Alignment(x, y),
                  end: Alignment.center,
                ).animate(animation),
                child: ScaleTransition(
                  scale: animation,
                  child: Material(
                    child: Card(
                      child: AddDeviceForm(),
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
