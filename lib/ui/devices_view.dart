import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasmota_plug_control/dev/manager.dart';

import 'plug_card.dart';

/// A column [PlugCard]s for [Manager.plugs] available in context.
class DevicesView extends StatelessWidget {
  const DevicesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Convert to list so provider detects the change
    final plugs = context.select((Manager manager) => manager.plugs.toList(growable: false));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final plug in plugs)
          PlugCard(
            plug: plug,
          ),
      ],
    );
  }
}
