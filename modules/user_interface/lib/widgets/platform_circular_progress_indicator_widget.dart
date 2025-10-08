import 'package:flutter/material.dart';
import 'package:user_interface/resources/values.dart';

class PlatformCircularProgressIndicatorWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;

  const PlatformCircularProgressIndicatorWidget({
    super.key,
    this.height,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? Values.circularProgressSize,
      height: height ?? Values.circularProgressSize,
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: color ?? Colors.white,
        ),
      ),
    );
  }
}
