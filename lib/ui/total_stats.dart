import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasmota_plug_control/dev/manager.dart';
import 'package:tasmota_plug_control/dev/status.dart';

import 'simple_stats.dart';

/// Shows [Manager.total] from the [Manager] provided in context.
class TotalStats extends StatelessWidget {
  const TotalStats({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select<Manager, Status>((manager) => manager.total);
    return SimpleStats(
      total: status.total,
      current: status.current,
    );
  }
}
