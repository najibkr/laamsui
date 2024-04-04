/// Indicates what type of viewport size a device has.
/// Smallest size is `XXXS` and largest size is `XXXL`.
enum DeviceViewport {
  /// A viewport is considered to be `XXXS` if its `width`
  /// **OR** `height` is less than **OR** equal to `130px`.
  /// It usually means that the viewport is **too small**
  /// to display anything.
  xxxs,

  /// A viewport is considered to be `XXS` if its `width`
  /// **OR** `height` is less than **OR** equal to `290px`.
  /// It means that the viewport could be a watch
  /// or a device with similar **viewport size**.
  xxs,

  /// A viewport is considered to be `XS` if its `width`
  /// **OR** `height` is less than **OR** equal to `330px`.
  /// It means that the viewport could be a small mobile phone
  /// or a device with similar **viewport size**. It is best
  /// fit for old mobile phones with lower resolutions
  /// and smaller viewports.
  xs,

  /// A viewport is considered to be `S` if its `width`
  /// **OR** `height` is less than **OR** equal to `500px`.
  /// It means that the viewport could be a mobile phone
  /// or a device with similar **viewport size**.
  s,

  /// A viewport is considered to be `M` if its `width`
  /// **OR** `height` is less than **OR** equal to `770px`.
  /// It means that the viewport could be a small tablet
  /// or a device with similar **viewport size**.
  m,

  /// A viewport is considered to be `L` if its `width`
  /// **OR** `height` is less than **OR** equal to `1030px`.
  /// It means that the viewport could be a medium-sized tablet,
  /// a low resolution desktop or laptop or a device
  /// with similar **viewport size**.
  l,

  /// A viewport is considered to be `XL` if its `width`
  /// **OR** `height` is less than **OR** equal to `1290px`.
  /// It means that the viewport could be a tablet, a desktop,
  /// a laptop or a device with similar **viewport size**.
  xl,

  /// A viewport is considered to be `XXL` if its `width`
  /// **OR** `height` is less than **OR** equal to `1670px`.
  /// It means that the viewport could be a desktop, a laptop, a TV
  /// or a device with similar **viewport size**.
  xxl,

  /// A viewport is considered to be `XXXL` if its `width`
  /// **OR** `height` is less than **OR** equal to `1920px`.
  /// It means that the viewport could be a desktop, a laptop, a TV
  /// or a device with similar **viewport size**.
  xxxl,

  @Deprecated('Use [xxxs] instead')
  tooSmall,

  @Deprecated('Use [xxs] instead')
  watch,

  @Deprecated('Use [xs] instead')
  mobileS,

  @Deprecated('Use [s] instead')
  mobile,

  @Deprecated('Use [s] instead')
  mobileL,
  @Deprecated('Use [m] instead')
  tabletS,
  @Deprecated('Use [l] instead')
  tabletM,
  @Deprecated('Use [DeviceViewport.xl] instead')
  tabletL,
  @Deprecated('Use [xxl] instead')
  desktop,
}

extension DeviceViewportExt on DeviceViewport {
  /// A viewport is considered to be `XXXS` if its `width`
  /// **OR** `height` is less than **OR** equal to `130px`.
  /// It usually means that the viewport is **too small**
  /// to display anything.
  bool get isXXXS => this == DeviceViewport.xxxs;

  /// A viewport is considered to be `XXS` if its `width`
  /// **OR** `height` is less than **OR** equal to `290px`.
  /// It means that the viewport could be a watch
  /// or a device with similar **viewport size**.
  bool get isXXS => this == DeviceViewport.xxs;

  /// A viewport is considered to be `XS` if its `width`
  /// **OR** `height` is less than **OR** equal to `330px`.
  /// It means that the viewport could be a small mobile phone
  /// or a device with similar **viewport size**. It is best
  /// fit for old mobile phones with lower resolutions
  /// and smaller viewports.
  bool get isXS => this == DeviceViewport.xs;

  /// A viewport is considered to be `S` if its `width`
  /// **OR** `height` is less than **OR** equal to `500px`.
  /// It means that the viewport could be a mobile phone
  /// or a device with similar **viewport size**.
  bool get isS => this == DeviceViewport.s;

  /// A viewport is considered to be `M` if its `width`
  /// **OR** `height` is less than **OR** equal to `770px`.
  /// It means that the viewport could be a small tablet
  /// or a device with similar **viewport size**.
  bool get isM => this == DeviceViewport.m;

  /// A viewport is considered to be `L` if its `width`
  /// **OR** `height` is less than **OR** equal to `1030px`.
  /// It means that the viewport could be a medium-sized tablet,
  /// a low resolution desktop or laptop or a device
  /// with similar **viewport size**.
  bool get isL => this == DeviceViewport.l;

  /// A viewport is considered to be `XL` if its `width`
  /// **OR** `height` is less than **OR** equal to `1290px`.
  /// It means that the viewport could be a tablet, a desktop,
  /// a laptop or a device with similar **viewport size**.
  bool get isXL => this == DeviceViewport.xl;

  /// A viewport is considered to be `XXL` if its `width`
  /// **OR** `height` is less than **OR** equal to `1670px`.
  /// It means that the viewport could be a desktop, a laptop, a TV
  /// or a device with similar **viewport size**.
  bool get isXXL => this == DeviceViewport.xxl;

  /// A viewport is considered to be `XXXL` if its `width`
  /// **OR** `height` is less than **OR** equal to `1920px`.
  /// It means that the viewport could be a desktop, a laptop, a TV
  /// or a device with similar **viewport size**.
  bool get isXXXL => this == DeviceViewport.xxxl;
}
