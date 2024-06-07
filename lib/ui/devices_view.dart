import 'package:flutter/material.dart';

import 'device_control.dart';

class DevicesView extends StatelessWidget {
  const DevicesView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: actual data
    // Column (mainax: min)
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DeviceControl(address: 'ddplug1'),
        DeviceControl(address: 'ddplug2'),
      ],
    );
  }
}
