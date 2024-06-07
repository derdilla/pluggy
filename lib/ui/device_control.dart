import 'dart:math';

import 'package:flutter/material.dart';
import 'package:heart/heart.dart';

import 'simple_stats.dart';

class DeviceControl extends StatelessWidget {
  const DeviceControl({super.key, required this.address});

  /// IP-Address and port of the plug to control.
  final String address;

  @override
  Widget build(BuildContext context) {
    // TODO: implement logic
    final rng = Random(address.codeUnits.sum());
    final total = rng.nextDouble() * 1000;
    final current = rng.nextDouble() * 300;

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: Text(address),
            value: true,
            onChanged: (v) {}, // TODO: tile color
          ),
          SimpleStats(
            total: total,
            current: current,
          ),
        ],
      ),
    );
  }
}
