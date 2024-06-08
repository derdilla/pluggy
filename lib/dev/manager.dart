import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';

import 'plug.dart';
import 'status.dart';

class Manager extends ChangeNotifier {
  Manager({
    List<Plug>? plugs
  }) : _plugs = plugs ?? [];

  final List<Plug> _plugs;

  factory Manager.deserialize(String serialized) => Manager(
    plugs: serialized
      .split(',')
      .map((ip) => Plug(ip))
      .toList(),
  );

  String serialize() => _plugs
    .map((plug) => plug.address)
    .join(',');

  void add(Plug plug) {
    _plugs.add(plug);
    notifyListeners();
  }

  UnmodifiableListView<Plug> get plugs => UnmodifiableListView(_plugs);

  Status get _total => _plugs
    .map((plug) => plug.lastStatus)
    .fold(Status.none(), (prev, status) => prev + status);

  Stream<Status> get total => Stream.periodic(
    Duration(milliseconds: 500),
    (_) => _total,
  );
}