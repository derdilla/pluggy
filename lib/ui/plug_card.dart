
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
    builder: (context, _child) => InkWell(
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
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(plug.address),
              trailing: Switch(
                value: plug.status.active,
                onChanged: _onToggleSwitch,
              ),
            ),
            SimpleStats(
              total: plug.status.total,
              current: plug.status.current,
            ),
          ],
        ),
      ),
    ),
  );

  void _onToggleSwitch([bool? newValue]) {
    if (plug.status.active) {
      plug.off();
    } else {
      plug.on();
    }
  }
}
