import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tasmota_plug_controll/dev/status.dart';

class Plug {
  Plug(this.address) {
    _updateStatus();
    Timer.periodic(Duration(milliseconds: 50), (Timer t) => _updateStatus());
    // TODO: consider interpolation
    status.listen((status) => _lastStatus = status);
  }

  /// Address in format: `192.168.178.46
  final String address;

  final StreamController<Status> _streamController = StreamController
    .broadcast();

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
    _updateStatus();
  }

  Future<void> off() async {
    final response = await _sendCommand('Power OFF');
    assert(response == '{"POWER":"OFF"}');
    _updateStatus();
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
        await _fetchActive(),
        (energyMap['Total'] is int)
          ? (energyMap['Total'] as int).toDouble()
          : (energyMap['Total'] as double),
        (energyMap['Power'] is int)
          ? (energyMap['Power'] as int).toDouble()
          : (energyMap['Power'] as double),
      ));
    } on http.ClientException {
      // Do nothing
    } catch (e) {
      debugPrint(e.toString());
      debugPrintStack();
    }
  }

  Future<bool> _fetchActive() async {
    final String response = await _sendCommand('Power');

    if (response == '{"POWER":"ON"}') {
      return true;
    } else {
      assert(response == '{"POWER":"OFF"}');
      return false;
    }
  }
  // When problems: consider power separate from data.
}
