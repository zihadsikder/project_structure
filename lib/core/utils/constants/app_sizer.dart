import 'package:flutter/material.dart';

const double kFigmaDesignWidth = 390;
const double kFigmaDesignHeight = 844;
const double kFigmaDesignStatusBar = 0;

enum DeviceType { mobile, tablet, desktop }

typedef ResponsiveBuild = Widget Function(
    BuildContext context,
    Orientation orientation,
    DeviceType deviceType,
    );


extension ResponsiveExtension on num {
  double get w => (this * SizeUtils.width) / kFigmaDesignWidth;
  double get h => (this * SizeUtils.height) / kFigmaDesignHeight;
  double get sp => (this * SizeUtils.width) / kFigmaDesignWidth;
}


extension FormatExtension on double {
  double toFixed(int fractionDigits) => double.parse(toStringAsFixed(fractionDigits));
  double nonZero({double defaultValue = 0.0}) => this > 0 ? this : defaultValue;
  String toFormattedString({int fractionDigits = 2}) => toStringAsFixed(fractionDigits);
}

class Sizer extends StatelessWidget {
  const Sizer({super.key, required this.builder});
  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeUtils.setScreenSize(constraints, orientation, context);
            return builder(
              context,
              orientation,
              SizeUtils.deviceType,
            );
          },
        );
      },
    );
  }
}

class SizeUtils {
  static late BoxConstraints boxConstraints;
  static late Orientation orientation;
  static late DeviceType deviceType;
  static late double width;
  static late double height;
  static late EdgeInsets safeAreaPadding;
  static bool debugMode = false;
  static void setScreenSize(
      BoxConstraints constraints,
      Orientation currentOrientation,
      BuildContext context,
      ) {
    boxConstraints = constraints;
    orientation = currentOrientation;
    safeAreaPadding = MediaQuery.of(context).padding;

    if (orientation == Orientation.portrait) {
      width = boxConstraints.maxWidth.nonZero(defaultValue: kFigmaDesignWidth);
      height = boxConstraints.maxHeight.nonZero();
    } else {
      width = boxConstraints.maxHeight.nonZero(defaultValue: kFigmaDesignWidth);
      height = boxConstraints.maxWidth.nonZero();
    }
    if (width >= 1200) {
      deviceType = DeviceType.desktop;
    } else if (width >= 600) {
      deviceType = DeviceType.tablet;
    } else {
      deviceType = DeviceType.mobile;
    }
    if (debugMode) debugPrintInfo();
  }

  static void debugPrintInfo() {
    debugPrint("Device Width: $width");
    debugPrint("Device Height: $height");
    debugPrint("Safe Area Padding: $safeAreaPadding");
    debugPrint("Device Type: $deviceType");
    debugPrint("Orientation: $orientation");
  }
  static double adaptivePadding({
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
  static bool get isPortrait => orientation == Orientation.portrait;
  static bool get isLandscape => orientation == Orientation.landscape;
}