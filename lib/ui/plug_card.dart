
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasmota_plug_control/dev/manager.dart';
import 'package:tasmota_plug_control/dev/plug.dart';
import 'package:tasmota_plug_control/ui/plug_settings.dart';

import 'dialog_helper.dart';
import 'simple_stats.dart';

/// A card that displays information about a plug and allows toggling it.
class PlugCard extends StatelessWidget {
  /// Create a card to manage a plug.
  const PlugCard({super.key, required this.plug});

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
            onChanged: (_) async {
              bool res;
              if (plug.status.active) {
                res = await plug.off();
              } else {
                res = await plug.on();
              }
              if (!res) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Failed to toggle power! Connection error.')
                ));
              }
            },
          ),
          InkWell(
            onTapDown: (details) {
              showCustomDialog(
                context,
                details.globalPosition,
                'configure plug',
                PlugSettings(
                  delete: () => context.read<Manager>().remove(plug),
                )
              );
            },
            child: SimpleStats(
              total: plug.status.total,
              current: plug.status.current,
            ),
          ),
        ],
      ),
    ),
  );
}
