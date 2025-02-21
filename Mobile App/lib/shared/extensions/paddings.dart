import 'package:flutter/material.dart';

extension PaddingsExpension on num {
  EdgeInsets get padVertical => EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get padHorizontal => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get padAll => EdgeInsets.all(toDouble());
  EdgeInsets get padTop => EdgeInsets.only(top: toDouble());
  EdgeInsets get padBottom => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get padLeft => EdgeInsets.only(left: toDouble());
  EdgeInsets get padRight => EdgeInsets.only(right: toDouble());
}
