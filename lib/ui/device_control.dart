
import 'package:flutter/material.dart';
import 'package:tasmota_plug_control/dev/plug.dart';

import 'simple_stats.dart';

/// A card that displays information about a plug and allows toggling it.
class DeviceControl extends StatelessWidget {
  /// Create a card to manage a plug.
  const DeviceControl({super.key, required this.plug});

  /// IP-Address and port of the plug to control.
  final Plug plug;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: plug,
    builder: (context, _child) => Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: Text(plug.address),
            value: plug.status.active,
            onChanged: (v) {
              if (plug.status.active) {
                plug.off();
              } else {
                plug.on();
              }
            },
          ),
          SimpleStats(
            total: plug.status.total,
            current: plug.status.current,
          ),
        ],
      ),
    ),
  );
}
