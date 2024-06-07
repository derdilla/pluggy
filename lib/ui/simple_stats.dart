import 'package:flutter/material.dart';

class SimpleStats extends StatelessWidget {
  const SimpleStats({super.key, required this.total, required this.current});

  /// Total consumption in Wh.
  final double total;

  /// Current consumption in W.
  final double current; // TODO: stream

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildBox(
          top: Text('Current',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          bottom: Text('${current.toStringAsFixed(2)}W'),
        ),
        _buildBox(
          top: Text('Total',
            style: Theme.of(context).textTheme.titleMedium),
          bottom: Text('${total.toStringAsFixed(2)}Wh'),
        ),
      ],
    );
  }

  Widget _buildBox({
    required Widget top,
    required Widget bottom,
  }) => SizedBox(
    height: 80.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        top,
        bottom,
      ],
    ),
  );
}
