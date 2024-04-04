enum DevicePlatform {
  ios,
  android,
  macOS,
  linux,
  windows,
  chrome,
  fuchsia,
  web,
}

extension DevicePlatformExt on DevicePlatform {
  bool get isIos => this == DevicePlatform.ios;
  bool get isAndroid => this == DevicePlatform.android;
  bool get isMacOS => this == DevicePlatform.macOS;
  bool get isWindows => this == DevicePlatform.windows;
  bool get isLinux => this == DevicePlatform.linux;
  bool get isChrome => this == DevicePlatform.chrome;
  bool get isFuchsia => this == DevicePlatform.fuchsia;
  bool get isWeb => this == DevicePlatform.web;
}
