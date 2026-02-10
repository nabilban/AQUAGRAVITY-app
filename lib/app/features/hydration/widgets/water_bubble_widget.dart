import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../../ui/constants/app_dimens.dart';
import '../../../ui/constants/app_animations.dart';

/// Interactive water bubble widget with gravity effects
class WaterBubbleWidget extends StatefulWidget {
  final bool isDehydrated;
  final double progress;
  final VoidCallback onTap;

  const WaterBubbleWidget({
    super.key,
    required this.isDehydrated,
    required this.progress,
    required this.onTap,
  });

  @override
  State<WaterBubbleWidget> createState() => _WaterBubbleWidgetState();
}

class _WaterBubbleWidgetState extends State<WaterBubbleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.floatDuration,
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation =
        Tween<double>(
          begin: -AppAnimations.floatAmplitude,
          end: AppAnimations.floatAmplitude,
        ).animate(
          CurvedAnimation(parent: _controller, curve: AppAnimations.floatCurve),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // If dehydrated, show floating glassmorphic bubble
    if (widget.isDehydrated) {
      return AnimatedBuilder(
        animation: _floatAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: child,
          );
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: GlassmorphicContainer(
            width: AppDimens.bubbleSizeLarge,
            height: AppDimens.bubbleSizeLarge,
            borderRadius: AppDimens.bubbleSizeLarge / 2,
            blur: 20,
            alignment: Alignment.center,
            border: 2,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary.withValues(alpha: 0.2),
                colorScheme.secondary.withValues(alpha: 0.1),
              ],
            ),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary.withValues(alpha: 0.5),
                colorScheme.secondary.withValues(alpha: 0.5),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.water_drop, size: 48, color: colorScheme.primary),
                const SizedBox(height: 8),
                Text(
                  'Tap to\nHydrate',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // If hydrated, show grounded solid bubble
    return AnimatedContainer(
      duration: AppAnimations.groundDuration,
      curve: AppAnimations.groundCurve,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: AppDimens.bubbleSizeLarge,
          height: AppDimens.bubbleSizeLarge,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorScheme.primary, colorScheme.secondary],
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.water_drop, size: 48, color: colorScheme.onPrimary),
              const SizedBox(height: 8),
              Text(
                '${(widget.progress * 100).toInt()}%',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
