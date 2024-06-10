# Pluggy

A simple controller for [tasmota](https://github.com/arendst/tasmota) smart plugs.

This tool shows current and total power consumption of individual devices and allows toggling the power. It provides cumulative stats of all listed plugs.

#### Releasing

1. increase both version parts in `pubspec.yaml`
2. Run build command (maybe add signing key)

```bash
flutter build apk --release
```

#### Updating icons

```bash
flutter pub run flutter_launcher_icons
```