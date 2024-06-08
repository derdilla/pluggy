import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dev/manager.dart';
import 'ui/add_device_button.dart';
import 'ui/devices_view.dart';
import 'ui/total_stats.dart';

class PlugControlApp extends StatelessWidget {
  const PlugControlApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData.dark(),
    home: Scaffold(
      body: Provider(
        create: (_) => Manager(),
        child: const CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: TotalStats()),
            SliverToBoxAdapter(child: DevicesView()),
            SliverFillRemaining(child: AddDeviceButton()),
          ],
        ),
      ),
    ),
  );
}
