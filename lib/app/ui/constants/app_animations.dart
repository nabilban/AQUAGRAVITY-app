import 'package:flutter/animation.dart';

/// Animation constants for gravity-based UI effects
class AppAnimations {
  AppAnimations._(); // Private constructor to prevent instantiation

  // Animation durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Gravity-specific durations
  static const Duration floatDuration = Duration(milliseconds: 1500);
  static const Duration groundDuration = Duration(milliseconds: 600);
  static const Duration bubbleLiftDuration = Duration(milliseconds: 400);

  // Animation curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve floatCurve = Curves.easeInOutSine;
  static const Curve groundCurve = Curves.easeOutBack; // Settles with bounce
  static const Curve bubbleLiftCurve = Curves.easeOutCubic;

  // Floating animation parameters
  static const double floatAmplitude = 10.0; // pixels
  static const double driftAmplitude = 5.0; // pixels
}
