import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppLoader extends StatelessWidget {
  final Color color;
  final double size;

  const AppLoader({
    super.key,
    this.color = Colors.blue,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(
        color: color,
        size: size,
      ),
    );
  }
}
