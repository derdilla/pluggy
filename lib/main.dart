import 'dart:io';

import 'package:flutter/material.dart';

import 'app.dart';
import 'dev/manager.dart';
void main() async {
  final manager = _loadManager();
  manager.addListener(() => _saveManager(manager));

  runApp(PlugControlApp(
    manager: manager
  ));
}

Manager _loadManager() {
  final file = File('devlist');
  if (file.existsSync()) {
    try {
      final data = file.readAsStringSync();
      return Manager.deserialize(data);
    } on FileSystemException {
      try {
        file.deleteSync();
      } on FileSystemException {
        // Do nothing
      }
    }
  }
  return Manager();
}

void _saveManager(Manager manager) {
  try {
    File('devlist').writeAsStringSync(manager.serialize());
  } on FileSystemException {
    print('Persisting data failed.');
  }
}
