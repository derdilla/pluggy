import 'package:flutter/material.dart';

import 'app.dart';
// import 'dev/plug_connection.dart';

void main() async {
  /* test code
  final con = PlugConnection('192.168.178.46');
  final sub = con.status.listen((d) => print(d));
  await sub.asFuture();
  */
  // TODO: manager persistence
  runApp(const PlugControlApp());
}
