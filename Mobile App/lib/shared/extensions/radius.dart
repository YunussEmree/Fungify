import 'package:flutter/material.dart';

extension AppBorderRadiusExtension on num {
  BorderRadius get radiusVertical => BorderRadius.vertical(
        top: Radius.circular(toDouble()),
        bottom: Radius.circular(toDouble()),
      );
  BorderRadius get radiusHorizontal => BorderRadius.horizontal(
        left: Radius.circular(toDouble()),
        right: Radius.circular(toDouble()),
      );
  BorderRadius get radiusAll => BorderRadius.circular(toDouble());
  BorderRadius get radiusTop => BorderRadius.only(
        topLeft: Radius.circular(toDouble()),
        topRight: Radius.circular(toDouble()),
      );
  BorderRadius get radiusTopLeft => BorderRadius.only(
        topLeft: Radius.circular(toDouble()),
      );
  BorderRadius get radiusTopRight => BorderRadius.only(
        topRight: Radius.circular(toDouble()),
      );
  BorderRadius get radiusBottom => BorderRadius.only(
        bottomLeft: Radius.circular(toDouble()),
        bottomRight: Radius.circular(toDouble()),
      );
  BorderRadius get radiusBottomLeft =>
      BorderRadius.only(bottomLeft: Radius.circular(toDouble()));
  BorderRadius get radiusBottomRight =>
      BorderRadius.only(bottomRight: Radius.circular(toDouble()));
  BorderRadius get radiusCircular => BorderRadius.circular(toDouble());
}
