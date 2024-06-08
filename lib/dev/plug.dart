import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:transmota_plug_controll/dev/status.dart';

class Plug {
  Plug(this.address) {
    Timer.periodic(Duration(milliseconds: 100), (Timer t) => _updateStatus());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateActive());
    status.listen((status) => _lastStatus = status);
  }

  /// Address in format: `192.168.178.46
  final String address;

  final StreamController<Status> _streamController = StreamController.broadcast();

  bool _active = false;

  Status _lastStatus = Status.none();

  Future<String> _sendCommand(String cmnd) async {
    final url = Uri.http(address, 'cm', {
      'cmnd': cmnd,
    });
    final response = await http.get(url);
    return response.body;
  }

  Future<void> on() async {
    final response = await _sendCommand('Power ON');
    assert(response == '{"POWER":"ON"}');
    _active = true;
  }

  Future<void> off() async {
    final response = await _sendCommand('Power OFF');
    assert(response == '{"POWER":"OFF"}');
    _active = false;
  }

  Stream<Status> get status => _streamController.stream;

  Status get lastStatus => _lastStatus;

  Future<void> _updateStatus() async {
    try {
      final response = await _sendCommand('status 10');
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

      _streamController.add(Status(
        _active,
        (energyMap['Total'] is int)
          ? (energyMap['Total'] as int).toDouble()
          : (energyMap['Total'] as double),
        (energyMap['Power'] is int)
            ? (energyMap['Power'] as int).toDouble()
            : (energyMap['Power'] as double),
      ));
    } catch (e) {
      debugPrint(e.toString());
      debugPrintStack();
    }
  }

  Future<void> _updateActive() async {
    final String response = await _sendCommand('Power');

    final updates = ((response == '{"POWER":"ON"}') != _active);

    if (response == '{"POWER":"ON"}') {
      _active = true;
    } else {
      assert(response == '{"POWER":"OFF"}');
      _active = false;
    }

    if (updates) await _updateStatus();
  }

}
