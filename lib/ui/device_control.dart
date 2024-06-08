import 'dart:math';

import 'package:flutter/material.dart';
import 'package:heart/heart.dart';
import 'package:provider/provider.dart';
import 'package:transmota_plug_controll/dev/plug.dart';
import 'package:transmota_plug_controll/dev/status.dart';

import 'simple_stats.dart';

class DeviceControl extends StatelessWidget {
  const DeviceControl({super.key, required this.plug});

  /// IP-Address and port of the plug to control.
  final Plug plug;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: Text(plug.address),
            value: plug.lastStatus.active,
            onChanged: (v) {
              if (plug.lastStatus.active) {
                plug.off();
              } else {
                plug.on();
              }
            }, // TODO: tile color
          ),
          StreamBuilder(
            stream: plug.status,
            builder: (context, snapshot) => SimpleStats(
              total: snapshot.data?.total ?? 0.0,
              current: snapshot.data?.current ?? 0.0,
            ),
          ),
        ],
      ),
    );
  }
}
