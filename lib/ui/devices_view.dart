import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transmota_plug_controll/dev/manager.dart';

import 'device_control.dart';

class DevicesView extends StatelessWidget {
  const DevicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final plug in context.watch<Manager>().plugs)
          DeviceControl(
            plug: plug,
          ),
      ],
    );
  }
}
