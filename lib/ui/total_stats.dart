import 'package:flutter/material.dart';

import 'simple_stats.dart';

class TotalStats extends StatelessWidget {
  const TotalStats({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: actual data
    return const SimpleStats(total: 123, current: 15,);
  }
}
