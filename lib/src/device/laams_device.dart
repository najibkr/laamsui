import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'device_platform.dart';
import 'device_viewport.dart';

class LaamsDevice {
  LaamsDevice._();

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

  /// Returns the current **Device** viewport.
  static DeviceViewport viewport(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final width = deviceSize.width;
    final height = deviceSize.height;

    /// XXXL:
    final isXXXL = width > _xxlBreakpoint;
    if (isXXXL) return DeviceViewport.xxxl;

    // XXL
    final isXXL = width > _xlBreakpoint;
    if (isXXL) return DeviceViewport.xxl;

    // XL
    final isXL = width > _lBreakpoint;
    if (isXL) return DeviceViewport.xl;

    // L
    final isL = width > _mBreakpoint;
    if (isL) return DeviceViewport.l;

    // M
    final isM = width > _sBreakpoint;
    if (isM) return DeviceViewport.m;

    // S
    final isS = width > _xsBreakpoint;
    if (isS) return DeviceViewport.s;

    // XS
    final isXS = width > _xxsBreakpoint;
    if (isXS) return DeviceViewport.xs;

    // XXS
    final isXXS = width > _xxxsBreakpoint && height > _xxxsBreakpoint;
    if (isXXS) return DeviceViewport.xxs;
    return DeviceViewport.xxxs;
  }

  /// Returns `true` if the viewport `width` is smaller than or equal to `130px`,
  /// **OR** the viewport `height` is smaller than or equal to `130px`.
  static bool isXXXS(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isCorrectWidth = size.width <= _xxxsBreakpoint;
    final isCorrectHeight = size.height <= _xxxsBreakpoint;
    return isCorrectWidth || isCorrectHeight;
  }

  /// Returns `true` if the provided [size] is smaller than or equal to `130px`.
  static bool isSizeXXXS(double size) {
    return size <= _xxxsBreakpoint;
  }

  /// Returns `true` if the viewport `width` is smaller than or equal to `290px`,
  /// **AND** the viewport `height` is smaller than or equal to `290px`.
  static bool isXXS(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isCorrectWidth = size.width <= _xxsBreakpoint;
    final isCorrectHeight = size.height <= _xxsBreakpoint;
    return isCorrectWidth && isCorrectHeight;
  }

  /// Returns `true` if the provided [size] is smaller than or equal to `290px`.
  static bool isSizeXXS(double size) {
    return size <= _xxsBreakpoint;
  }

  /// Returns `true` if the viewport `width` is smaller than
  /// or equal to `330px`,
  static bool isXS(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width <= _xsBreakpoint;
  }

  /// Returns `true` if the provided [size] is smaller than
  /// **OR** equal to `330px`.
  static bool isSizeXS(double size) {
    return size <= _xsBreakpoint;
  }

  /// Returns `true` if the viewport `width` is smaller than
  ///  **OR** equal to `500px`,
  static bool isS(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width <= _sBreakpoint;
  }

  /// Returns `true` if the provided [size] is smaller than
  /// **OR** equal to `500px`.
  static bool isSizeS(double size) {
    return size <= _sBreakpoint;
  }

  /// Returns `true` if the viewport `width` is smaller than
  ///  **OR** equal to `770px`,
  static bool isM(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width <= _mBreakpoint;
  }

  /// Returns `true` if the provided [size] is smaller than
  /// **OR** equal to `770px`.
  static bool isSizeM(double size) {
    return size <= _mBreakpoint;
  }

  /// Returns `true` if the viewport `width` is smaller than
  ///  **OR** equal to `1030px`,
  static bool isL(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width <= _lBreakpoint;
  }

  /// Returns `true` if the provided [size] is smaller than
  /// **OR** equal to `1030px`.
  static bool isSizeL(double size) {
    return size <= _lBreakpoint;
  }

  /// Returns `true` if the viewport `width` is smaller than
  ///  **OR** equal to `1290px`,
  static bool isXL(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width <= _xlBreakpoint;
  }

  /// Returns `true` if the provided [size] is smaller than
  /// **OR** equal to `1290px`.
  static bool isSizeXL(double size) {
    return size <= _xlBreakpoint;
  }

  /// Returns `true` if the viewport `width` is smaller than
  ///  **OR** equal to `1670px`,
  static bool isXXL(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width <= _xxlBreakpoint;
  }

  /// Returns `true` if the provided [size] is smaller than
  /// **OR** equal to `1670px`.
  static bool isSizeXXL(double size) {
    return size <= _xxlBreakpoint;
  }

  /// Returns `true` if the viewport `width` is smaller than
  ///  **OR** equal to `1920px`,
  static bool isXXXL(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width <= _xxxlBreakpoint;
  }

  /// Returns `true` if the provided [size] is smaller than
  /// **OR** equal to `1920px`.
  static bool isSizeXXXL(double size) {
    return size <= _xxxlBreakpoint;
  }

  //   // Breakpoints:
  // static const double _tooSmall = 295;

  // static const double _mobileLong = 930.0;
  // static const double _mobileShort = 500.0; // from 490

  // static const double _tabletSLong = 1200.0;
  // static const double _tabletSShort = 770.0;

  // static const double _tabletLLong = 1400;
  // static const double _tabletLShort = 1100;

  // New Breakpoints:
  static const double _mobileSMinWidth = 200;
  static const double _mobileSMaxWidth = 375;

  static const double _mobileLMinWidth = 376;
  static const double _mobileLMaxWidth = 500;

  static const double _tabletSMinWidth = 501;
  static const double _tabletSMaxWidth = 770;

  static const double _tabletMMinWidth = 771;
  static const double _tabletMMaxWidth = 950;

  static const double _tabletLMinWidth = 951;
  static const double _tabletLMaxWidth = 1200;

  static const double _desktopMinWidth = 1201;

  /// Gets the operating system of the device.
  /// The returned value could be one of the following:
  ///
  ///  `DevicePlatform.web`, `DevicePlatform.ios`,
  /// `DevicePlatform.android`, `DevicePlatform.macos`, `DevicePlatform.windows`,
  /// `DevicePlatform.linux` or `DevicePlatform.fuchsia`
  static DevicePlatform get platform {
    if (kIsWeb) return DevicePlatform.web;
    if (Platform.isIOS) return DevicePlatform.ios;
    if (Platform.isAndroid) return DevicePlatform.android;
    if (Platform.isMacOS) return DevicePlatform.macOS;
    if (Platform.isWindows) return DevicePlatform.windows;
    if (Platform.isLinux) return DevicePlatform.linux;
    if (Platform.isFuchsia) return DevicePlatform.fuchsia;
    return DevicePlatform.web;
  }

  /// Gets the device orientation.
  /// The returned value can be one of the following:
  ///
  /// `Orientation.portrait` or `Orientation.landscape`
  static Orientation orientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  /// Returns true if the device orientation is **Portrait** and
  /// returns `false` if the device orientation is **Landscape**
  static bool isPortrait(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.portrait;
  }

  /// Returns `true` if the device orientation is **Landscape** and
  /// returns `false` if the device orientation is **Portrait**
  static bool isLandscape(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape;
  }

  /// Displays the current **Device** viewport. It returns one of the following:
  ///
  /// `DeviceViewport.tooSmall`,`DeviceViewport.mobileS`, `DeviceViewport.mobileL`,
  /// `DeviceViewport.tabletS`, `DeviceViewport.tabletM`, `DeviceViewport.tabletL`,
  /// or `DeviceViewport.desktop`,
  @Deprecated('Use [viewport] instead')
  static DeviceViewport viewporta(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final width = deviceSize.width;
    final height = deviceSize.height;

    // Too small:
    final isTooSmall = width < _mobileSMinWidth || height < _mobileSMinWidth;
    if (isTooSmall) return DeviceViewport.tooSmall;

    // Mobile Small:
    final isMobileS = width >= _mobileSMinWidth && width <= _mobileSMaxWidth;
    if (isMobileS) return DeviceViewport.mobileS;

    // Mobile Large:
    final isMobileL = width >= _mobileLMinWidth && width <= _mobileLMaxWidth;
    if (isMobileL) return DeviceViewport.mobileL;

    // Tablet Small:
    final isTabletS = width >= _tabletSMinWidth && width <= _tabletSMaxWidth;
    if (isTabletS) return DeviceViewport.tabletS;

    // Tablet Midiam:
    final isTabletM = width >= _tabletMMinWidth && width <= _tabletMMaxWidth;
    if (isTabletM) return DeviceViewport.tabletM;

    // Tablet Large:
    final isTabletL = width >= _tabletLMinWidth && width <= _tabletLMaxWidth;
    if (isTabletL) return DeviceViewport.tabletL;

    // Desktop
    if (width >= _desktopMinWidth) return DeviceViewport.desktop;
    return DeviceViewport.desktop;
  }

  @Deprecated('Use [isXS] instead')
  static bool isMobileS(BuildContext context) {
    final view = viewport(context);
    if (view == DeviceViewport.mobileS) return true;
    return false;
  }

  @Deprecated('Use [isS] instead')
  static bool isMobileL(BuildContext context) {
    final view = viewport(context);
    if (view == DeviceViewport.mobileL) return true;
    return false;
  }

  @Deprecated('Use [isS] instead')
  static bool isMobile(BuildContext context) {
    final view = viewport(context);
    if (view == DeviceViewport.mobileS) return true;
    if (view == DeviceViewport.mobileL) return true;
    return false;
  }

  @Deprecated('Use [isM] instead')
  static bool isNarrow(BuildContext context) {
    final view = viewport(context);
    final isMobileS = view == DeviceViewport.mobileS;
    final isMobileL = view == DeviceViewport.mobileL;
    final isTabletS = view == DeviceViewport.tabletS;
    return isMobileS || isMobileL || isTabletS;
  }

  @Deprecated('Use [isM] instead')
  static bool isTabletS(BuildContext context) {
    final view = viewport(context);
    if (view == DeviceViewport.tabletS) return true;
    return false;
  }

  @Deprecated('Use [isL] instead')
  static bool isTabletM(BuildContext context) {
    final view = viewport(context);
    if (view == DeviceViewport.tabletM) return true;
    return false;
  }

  @Deprecated('Use [isXL] instead')
  static bool isTabletL(BuildContext context) {
    final view = viewport(context);
    if (view == DeviceViewport.tabletL) return true;
    return false;
  }

  @Deprecated('Use [isXL] instead')
  static bool isTablet(BuildContext context) {
    final view = viewport(context);
    if (view == DeviceViewport.tabletS) return true;
    if (view == DeviceViewport.tabletM) return true;
    if (view == DeviceViewport.tabletL) return true;
    return false;
  }

  @Deprecated('Use [isXXL] instead')
  static bool isDesktop(BuildContext context) {
    final view = viewport(context);
    if (view == DeviceViewport.desktop) return true;
    return false;
  }
}
