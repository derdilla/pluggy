import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:tasmota_plug_control/dev/status.dart';

/// Abstraction of a plug in the network that provides status and sends commands.
class Plug extends ChangeNotifier {
  /// Create Plug and start loading initial [status]. 
  Plug(this.address) {
    updateStatus();
  }

  final http.Client _client = IOClient();

  /// Network address off the Plug to monitor.
  ///
  /// # Format examples:
  /// - `192.168.178.46`
  /// - `example.com`
  final String address;

  Status _lastStatus = Status.none();

  /// Last [Status] obtained on the last call to [updateStatus].
  Status get status => _lastStatus;

  /// Attempts to send a command to the plug and returns it's json response.
  ///
  /// All errors are caught and null is returned.
  Future<String?> _sendCommand(String cmnd, [int maxRetryCount = 0]) async {
    String? result;
    while (result == null && maxRetryCount >= 0) {
      maxRetryCount--;
      final url = Uri.http(address, 'cm', {
        'cmnd': cmnd,
      });
      try {
        await _client.get(url);
        final response = await http.get(url);
        result = response.body;
      } catch (e) {
        // Since undocumented exception apart from http.ClientException were
        // thrown (e.g. "Connection reset by peer", ...) network code isn't
        // trusted. Users of this function can determine when to retry
        // depending on context.
        assert(result == null);
      }
    }
    return result;
  }

  /// Send a power on command to the plug regardless of state.
  Future<bool> on() async {
    String? response = await _sendCommand('Power ON', 5);
    if(response == '{"POWER":"ON"}') {
      _lastStatus = _lastStatus.copyWith(active: true);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Send a power off command to the plug regardless of state.
  Future<bool> off() async {
    String? response = await _sendCommand('Power OFF', 5);
    if(response == '{"POWER":"OFF"}') {
      _lastStatus = _lastStatus.copyWith(active: false);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Fetch latest information from the plug and update the cached [status].
  Future<Status> updateStatus() async {
    final response = await _sendCommand('status 10');
    if (response != null) {
      final Map<String, dynamic> json = jsonDecode(response);
      try {
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

        final activeResponse = await _sendCommand('Power');
        bool active = status.active;
        if(activeResponse == '{"POWER":"ON"}') active = true;
        else if(activeResponse == '{"POWER":"OFF"}') active = false;

        _lastStatus = Status(
          active,
          (energyMap['Total'] is int)
              ? (energyMap['Total'] as int).toDouble()
              : (energyMap['Total'] as double),
          (energyMap['Power'] is int)
              ? (energyMap['Power'] as int).toDouble()
              : (energyMap['Power'] as double),
        );
        notifyListeners();
      } on NoSuchMethodError {
        // JSON format unexpected
        debugPrint('status JSON has unexpected format: $json');
      }
    }
    return _lastStatus;
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Plug &&
      runtimeType == other.runtimeType &&
      address == other.address &&
      _lastStatus == other._lastStatus;

  @override
  int get hashCode =>
    address.hashCode ^ _lastStatus.hashCode;
}
