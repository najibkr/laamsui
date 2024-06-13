import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart'
    show Directionality, TextDirection, TextTheme, Theme, ThemeData;
import 'package:flutter/widgets.dart'
    show BuildContext, Locale, Localizations, MediaQuery, Orientation, Size;

extension ViewportExtension on BuildContext {
  // Breakpoints: The provided values are considered to be `Viewport Pixels`,
  // not to be mistaken with `Resolution`.
  /// `130px` and below.
  static const double _xxxsBreakpoint = 130;

  /// `290px` and below.
  static const double _xxsBreakpoint = 290;

  /// `330px` and below.
  static const double _xsBreakpoint = 330;

  /// `500px` and below.
  static const double _sBreakpoint = 500;

  /// `770px` and below
  static const double _mBreakpoint = 770;

  /// `1030px` and below
  static const double _lBreakpoint = 1030;

  /// `1290px` and below
  static const double _xlBreakpoint = 1290;

  /// `1670px` and below
  static const double _xxlBreakpoint = 1670;

  /// `1920px` and blew
  static const double _xxxlBreakpoint = 1920;

  // Get Screen Size:
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Returns `true` if the viewport `width` is smaller than or equal to `130px`,
  /// **OR** the viewport `height` is smaller than or equal to `130px`.
  bool get isXXXS {
    final size = MediaQuery.sizeOf(this);
    final isCorrectWidth = size.width <= _xxxsBreakpoint;
    final isCorrectHeight = size.height <= _xxxsBreakpoint;
    return isCorrectWidth || isCorrectHeight;
  }

  /// Returns `true` if the provided [size] is smaller than or equal to `130px`.
  bool isSizeXXXS(double size) {
    return size <= _xxxsBreakpoint;
  }

  /// Returns `true` if the viewport `width` is smaller than or equal to `290px`,
  /// **AND** the viewport `height` is smaller than or equal to `290px`.
  bool get isXXS {
    final size = MediaQuery.sizeOf(this);
    final isCorrectWidth = size.width <= _xxsBreakpoint;
    final isCorrectHeight = size.height <= _xxsBreakpoint;
    return isCorrectWidth && isCorrectHeight;
  }

  /// Returns `true` if the provided [size] is smaller than or equal to `290px`.
  bool isSizeXXS(double size) {
    return size <= _xxsBreakpoint;
  }

  /// Returns `true` if the viewport `width` is smaller than
  /// or equal to `330px`,
  bool get isXS {
    final size = MediaQuery.sizeOf(this);
    return size.width <= _xsBreakpoint;
  }

  /// Returns `true` if the provided [size] is smaller than
  /// **OR** equal to `330px`.
  bool isSizeXS(double size) {
    return size <= _xsBreakpoint;
  }

  /// Returns `true` if the viewport `width` is smaller than
  ///  **OR** equal to `500px`,
  bool get isS {
    final size = MediaQuery.sizeOf(this);
    return size.width <= _sBreakpoint;
  }

  /// Returns `true` if the provided [size] is smaller than
  /// **OR** equal to `500px`.
  bool isSizeS(double size) {
    return size <= _sBreakpoint;
  }

  /// Returns `true` if the viewport `width` is smaller than
  ///  **OR** equal to `770px`,
  bool get isM {
    final size = MediaQuery.sizeOf(this);
    return size.width <= _mBreakpoint;
  }

  /// Returns `true` if the provided [size] is smaller than
  /// **OR** equal to `770px`.
  bool isSizeM(double size) {
    return size <= _mBreakpoint;
  }

  /// Returns `true` if the viewport `width` is smaller than
  ///  **OR** equal to `1030px`,
  bool get isL {
    final size = MediaQuery.sizeOf(this);
    return size.width <= _lBreakpoint;
  }

  /// Returns `true` if the provided [size] is smaller than
  /// **OR** equal to `1030px`.
  bool isSizeL(double size) {
    return size <= _lBreakpoint;
  }

  /// Returns `true` if the viewport `width` is smaller than
  ///  **OR** equal to `1290px`,
  bool get isXL {
    final size = MediaQuery.sizeOf(this);
    return size.width <= _xlBreakpoint;
  }

  /// Returns `true` if the provided [size] is smaller than
  /// **OR** equal to `1290px`.
  bool isSizeXL(double size) {
    return size <= _xlBreakpoint;
  }

  /// Returns `true` if the viewport `width` is smaller than
  ///  **OR** equal to `1670px`,
  bool get isXXL {
    final size = MediaQuery.sizeOf(this);
    return size.width <= _xxlBreakpoint;
  }

  /// Returns `true` if the provided [size] is smaller than
  /// **OR** equal to `1670px`.
  bool isSizeXXL(double size) {
    return size <= _xxlBreakpoint;
  }

  /// Returns `true` if the viewport `width` is smaller than
  ///  **OR** equal to `1920px`,
  bool get isXXXL {
    final size = MediaQuery.sizeOf(this);
    return size.width <= _xxxlBreakpoint;
  }

  /// Returns `true` if the provided [size] is smaller than
  /// **OR** equal to `1920px`.
  bool isSizeXXXL(double size) {
    return size <= _xxxlBreakpoint;
  }

  /// Returns true if the device orientation is **Portrait** and
  /// returns `false` if the device orientation is **Landscape**
  bool get isPortrait {
    final orientation = MediaQuery.orientationOf(this);
    return orientation == Orientation.portrait;
  }

  /// Returns `true` if the device orientation is **Landscape** and
  /// returns `false` if the device orientation is **Portrait**
  bool get isLandscape {
    final orientation = MediaQuery.orientationOf(this);
    return orientation == Orientation.landscape;
  }

  /// Gets the operating system of the device.
  /// The returned value could be one of the following:
  ///
  ///  `DevicePlatform.web`, `DevicePlatform.ios`,
  /// `DevicePlatform.android`, `DevicePlatform.macos`, `DevicePlatform.windows`,
  /// `DevicePlatform.linux` or `DevicePlatform.fuchsia`
  DevicePlatform get platform {
    if (kIsWeb) return DevicePlatform.web;
    if (Platform.isIOS) return DevicePlatform.ios;
    if (Platform.isAndroid) return DevicePlatform.android;
    if (Platform.isMacOS) return DevicePlatform.macOS;
    if (Platform.isWindows) return DevicePlatform.windows;
    if (Platform.isLinux) return DevicePlatform.linux;
    if (Platform.isFuchsia) return DevicePlatform.fuchsia;
    return DevicePlatform.web;
  }

  Locale get currentLocale {
    try {
      return Localizations.localeOf(this);
    } catch (e) {
      return const Locale('en', 'US');
    }
  }

  /// Returns [true] if directionality is right to left
  bool get isRTL {
    return Directionality.of(this) == TextDirection.rtl;
  }

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
}

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
