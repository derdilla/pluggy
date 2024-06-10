import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';

import 'plug.dart';
import 'status.dart';

/// Maintains the state of [Plug]s and a cumulative [total] value.
class Manager extends ChangeNotifier {
  /// Create a manager to maintain [plugs] and a cumulative [total] value.
  Manager({
    List<Plug>? plugs
  }) : _plugs = plugs ?? [] {
    _updateTimer = Timer.periodic(Duration(milliseconds: 1000 ~/ 15), (timer) async {
      final Iterable<Status> updated = await Future.wait(_plugs.map((plug) => plug.updateStatus()));
      _total = updated.fold(Status.none(), (a, b) => a + b);
      notifyListeners();
    });
  }

  /// Intervall periodically updating status of [_plugs] and [total].
  late final Timer _updateTimer;

  final List<Plug> _plugs;

  /// All plugs currently stored.
  ///
  /// Data inside plugs is automatically updated 30 times per second.
  UnmodifiableListView<Plug> get plugs => UnmodifiableListView(_plugs);

  /// Add a plug and start updating it regularly.
  void add(Plug plug) {
    _plugs.add(plug);
    print("Adding plug");
    notifyListeners();
  }

  /// Remove a plug and stop processing updates for it.
  void remove(Plug plug) {
    final bool removed = _plugs.remove(plug);
    assert(removed);
    notifyListeners();
  }

  Status _total = Status.none();

  /// Cumulative plug stats (current and total) as well es whether all are on.
  Status get total => _total;

  /// Construct a manager from output of the [serialize] method.
  factory Manager.deserialize(String serialized) => Manager(
    plugs: serialized
        .split(',')
        .map((ip) => Plug(ip))
        .toList(),
  );

  /// Save information needed to reconstruct the object.
  String serialize() => _plugs
      .map((plug) => plug.address)
      .join(',');

  @override
  void dispose() {
    _updateTimer.cancel();
    super.dispose();
  }
}