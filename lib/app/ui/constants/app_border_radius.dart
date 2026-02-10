import 'package:flutter/material.dart';

/// Application border radius constants
class AppBorderRadius {
  AppBorderRadius._(); // Private constructor to prevent instantiation

  static const BorderRadius small = BorderRadius.all(Radius.circular(8));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(12));
  static const BorderRadius large = BorderRadius.all(Radius.circular(16));
  static const BorderRadius xLarge = BorderRadius.all(Radius.circular(24));
  static const BorderRadius circular = BorderRadius.all(Radius.circular(999));

  // Specific component radii
  static const BorderRadius bubble = BorderRadius.all(Radius.circular(40));
  static const BorderRadius card = medium;
  static const BorderRadius button = medium;
}
