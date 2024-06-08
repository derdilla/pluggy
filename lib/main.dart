import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'dev/manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final manager = await _loadManager();
  manager.addListener(() => unawaited(_saveManager(manager)));

  runApp(PlugControlApp(
    manager: manager
  ));
}

Future<Manager> _loadManager() async {
  final File? file = await _getSaveFile();
  if (file == null) return Manager();

  String fileContent;
  try {
    fileContent = file.readAsStringSync();
  } on FileSystemException {
    print("Couldn't read saved plug ips.");
    return Manager();
  }

  try {
    return Manager.deserialize(fileContent);
  } catch (e) {
    print("Failed decoding saved ips.");
    file.deleteSync();
    return Manager();
  }
}

Future<void> _saveManager(Manager manager) async {
  try {
    final File? file = await _getSaveFile();
    if (file == null) {
      return;
    }
    file.writeAsStringSync(manager.serialize());
  } on FileSystemException {
    print('Persisting data failed.');
  }
}

Future<File?> _getSaveFile() async {
  Directory dir;
  try {
    dir = await getApplicationDocumentsDirectory();
  } on MissingPlatformDirectoryException {
    print('No application documents dir.');
    return null;
  }

  final filePath = join(dir.path, 'plgs.ips');
  return File(filePath);
}
