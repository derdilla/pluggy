import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tasmota_plug_control/dev/status.dart';

/// Abstraction of a plug in the network that provides status and sends commands.
class Plug extends ChangeNotifier {
  /// Create Plug and start loading initial [status]. 
  Plug(this.address) {
    updateStatus();
  }

  /// Network address off the Plug to monitor.
  ///
  /// # Format examples:
  /// - `192.168.178.46`
  /// - `example.com`
  final String address;

  Status _lastStatus = Status.none();

  /// Last [Status] obtained on the last call to [updateStatus].
  Status get status => _lastStatus;

  bool _offline = false;

  bool get offline => _offline;

  /// Attempts to send a command to the plug and returns it's json response.
  ///
  /// It sends the request regardless of [offline]. When the plug is actually
  /// offline "ERR-OFFLINE" will be returned. If not [offline] is updated.
  Future<String> _sendCommand(String cmnd) async {
    final url = Uri.http(address, 'cm', {
      'cmnd': cmnd,
    });
    try {
      final response = await http.get(url);
      if (offline) {
        _offline = false;
        notifyListeners();
      }
      return response.body;
    } on SocketException {
      if (!offline) {
        _offline = true;
        notifyListeners();
      }
      return "ERR-OFFLINE";
    }

  }

  /// Send a power on command to the plug regardless of state.
  Future<void> on() async {
    final response = await _sendCommand('Power ON');
    if (offline) return;
    assert(response == '{"POWER":"ON"}');
    _lastStatus = _lastStatus.copyWith(active: true);
    notifyListeners();
  }

  /// Send a power off command to the plug regardless of state.
  Future<void> off() async {
    final response = await _sendCommand('Power OFF');
    if (offline) return;
    assert(response == '{"POWER":"OFF"}');
    _lastStatus = _lastStatus.copyWith(active: false);
    notifyListeners();
  }

  /// Fetch latest information from the plug and update the cached [status].
  Future<Status> updateStatus() async {
    try {
      final response = await _sendCommand('status 10');
      if (offline) return _lastStatus;
      final Map<String, dynamic> json = jsonDecode(response);

      // Sample:
      // {
      //   "TotalStartTime": "2024-06-07T18:30:35",
      //   "Total": 0.447,
      //   "Yesterday": 0.378,
      //   "Today": 0.069,
      //   "Power": 80,
      //   "ApparentPower": 90,
      //   "ReactivePower": 43,
      //   "Factor": 0.88,
      //   "Voltage": 226,
      //   "Current": 0.400
      // }
      final Map<String, dynamic> energyMap = json['StatusSNS']['ENERGY'];

      _lastStatus = Status(
        (await _sendCommand('Power') == '{"POWER":"ON"}'),
        (energyMap['Total'] is int)
            ? (energyMap['Total'] as int).toDouble()
            : (energyMap['Total'] as double),
        (energyMap['Power'] is int)
            ? (energyMap['Power'] as int).toDouble()
            : (energyMap['Power'] as double),
      );
      notifyListeners();
    } on http.ClientException {
      // Do nothing
    } catch (e) {
      debugPrint(e.toString());
      debugPrintStack();
    }
    return _lastStatus;
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Plug &&
      runtimeType == other.runtimeType &&
      address == other.address &&
      _lastStatus == other._lastStatus &&
      _offline == other._offline;

  @override
  int get hashCode =>
    address.hashCode ^ _lastStatus.hashCode ^ _offline.hashCode;
}
