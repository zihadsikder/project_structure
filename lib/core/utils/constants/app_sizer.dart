import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

typedef ResponsiveBuild = Widget Function(
    BuildContext context,
    Orientation orientation,
    DeviceType deviceType,
    );

/// ------------------------------------------------------------
/// Extensions
/// ------------------------------------------------------------

extension ResponsiveExtension on num {
  double get w => this * SizeUtils.scaleWidth;
  double get h => this * SizeUtils.scaleHeight;
  double get sp => this * SizeUtils.scaleWidth;
}

extension FormatExtension on double {
  double toFixed(int fractionDigits) =>
      double.parse(toStringAsFixed(fractionDigits));

  double nonZero({double defaultValue = 0.0}) =>
      this > 0 ? this : defaultValue;
}


class Sizer extends StatelessWidget {
  const Sizer({super.key, required this.builder});

  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        SizeUtils.setScreenSize(orientation, context);
        return builder(
          context,
          orientation,
          SizeUtils.deviceType,
        );
      },
    );
  }
}

/// ------------------------------------------------------------
/// Size Utils (Viewport based – NO Figma)
/// ------------------------------------------------------------

class SizeUtils {
  static late Orientation orientation;
  static late DeviceType deviceType;

  static late double screenWidth;
  static late double screenHeight;

  /// scaling factors (relative)
  static late double scaleWidth;
  static late double scaleHeight;

  static late EdgeInsets safeAreaPadding;

  static bool debugMode = false;

  static void setScreenSize(
      Orientation currentOrientation,
      BuildContext context,
      ) {
    orientation = currentOrientation;

    /// 🔥 View based size (most accurate)
    final view = View.of(context);

    screenWidth =
        (view.physicalSize.width / view.devicePixelRatio)
            .nonZero(defaultValue: 360);

    screenHeight =
        (view.physicalSize.height / view.devicePixelRatio)
            .nonZero(defaultValue: 640);

    safeAreaPadding = MediaQuery.of(context).padding;

    /// Base scale = 1.0 (no figma dependency)
    scaleWidth = screenWidth / screenWidth;
    scaleHeight = screenHeight / screenHeight;

    /// Device type
    if (screenWidth >= 1200) {
      deviceType = DeviceType.desktop;
    } else if (screenWidth >= 600) {
      deviceType = DeviceType.tablet;
    } else {
      deviceType = DeviceType.mobile;
    }

    if (debugMode) debugPrintInfo();
  }

  static void debugPrintInfo() {
    debugPrint("Screen Width: $screenWidth");
    debugPrint("Screen Height: $screenHeight");
    debugPrint("Safe Area: $safeAreaPadding");
    debugPrint("Device Type: $deviceType");
    debugPrint("Orientation: $orientation");
  }

  static bool get isPortrait => orientation == Orientation.portrait;
  static bool get isLandscape => orientation == Orientation.landscape;

  static double adaptiveValue({
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    switch (deviceType) {
      case DeviceType.tablet:
        return tablet;
      case DeviceType.desktop:
        return desktop;
      default:
        return mobile;
    }
  }
}
