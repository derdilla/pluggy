import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasmota_plug_control/dev/manager.dart';

import 'simple_stats.dart';

class TotalStats extends StatelessWidget {
  const TotalStats({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.watch<Manager>().total,
      builder: (context, snapshot) => SimpleStats(
        total: snapshot.data?.total ?? 0.0,
        current: snapshot.data?.current ?? 0.0,
      ),
    );
  }
}
