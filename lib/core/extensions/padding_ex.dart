//! Padding extension
//* using : 16.hPadding
//* using : 16.vPadding
//* using : 16.vhPadding
//* using : 16.allPadding
//* using : 16.topPadding
//* using : 16.bottomPadding
//* using : 16.leftPadding
//* using : 16.rightPadding
import 'package:flutter/material.dart';

extension PaddingExtensions on num {
  EdgeInsetsDirectional get hPadding => EdgeInsetsDirectional.symmetric(horizontal: toDouble());
  EdgeInsetsDirectional get vPadding => EdgeInsetsDirectional.symmetric(vertical: toDouble());
  EdgeInsetsDirectional get vhPadding =>
      EdgeInsetsDirectional.symmetric(vertical: toDouble(), horizontal: toDouble());
  EdgeInsetsDirectional get allPadding => EdgeInsetsDirectional.all(toDouble());
  EdgeInsetsDirectional get topPadding => EdgeInsetsDirectional.only(top: toDouble());
  EdgeInsetsDirectional get bottomPadding => EdgeInsetsDirectional.only(bottom: toDouble());
  EdgeInsetsDirectional get leftPadding => EdgeInsetsDirectional.only(start: toDouble());
  EdgeInsetsDirectional get rightPadding => EdgeInsetsDirectional.only(end: toDouble());
}