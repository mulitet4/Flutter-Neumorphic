import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';

import '../neumorphic_box_shape.dart';
import '../decoration/neumorphic_decorations.dart';
import '../theme/neumorphic_theme.dart';
import 'clipper/neumorphic_box_shape_clipper.dart';

export '../neumorphic_box_shape.dart';
export '../decoration/neumorphic_decorations.dart';
export '../theme/neumorphic_theme.dart';

/// The main container of the Neumorphic UI KIT
/// it takes a Neumorphic style @see [NeumorphicStyle]
///
/// it's clipped using a [NeumorphicBoxShape] (circle, roundrect, stadium)
///
/// It can be, depending on its [NeumorphicStyle.shape] : [NeumorphicShape.concave],  [NeumorphicShape.convex],  [NeumorphicShape.flat]
///
/// if [NeumorphicStyle.depth] < 0 ----> use the emboss shape
///
/// The container animates any change for you, with [duration] ! (including style / theme / size / etc.)
///
/// [drawSurfaceAboveChild] enable to draw emboss, concave, convex effect above this widget child
///
/// drawSurfaceAboveChild - UseCase 1 :
///
///   put an image inside a neumorphic(concave) :
///   drawSurfaceAboveChild=false -> the concave effect is below the image
///   drawSurfaceAboveChild=true -> the concave effect is above the image, the image seems concave
///
/// drawSurfaceAboveChild - UseCase 2 :
///   put an image inside a neumorphic(emboss) :
///   drawSurfaceAboveChild=false -> the emboss effect is below the image -> not visible
///   drawSurfaceAboveChild=true -> the emboss effeect effect is above the image -> visible
///
@immutable
class Neumorphic extends StatelessWidget {
  static const DEFAULT_DURATION = const Duration(milliseconds: 100);
  static const DEFAULT_CURVE = Curves.linear;

  static const double MIN_DEPTH = -20.0;
  static const double MAX_DEPTH = 20.0;

  static const double MIN_INTENSITY = 0.0;
  static const double MAX_INTENSITY = 1.0;

  static const double MIN_CURVE = 0.0;
  static const double MAX_CURVE = 1.0;

  final Widget? child;

  final NeumorphicStyle? style;
  final TextStyle? textStyle;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Curve curve;
  final Duration duration;
  final bool
      drawSurfaceAboveChild; //if true => boxDecoration & foreground decoration, else => boxDecoration does all the work

  const Neumorphic({
    // Added const constructor
    super.key, // Updated to use super parameter
    this.child,
    this.duration = Neumorphic.DEFAULT_DURATION, // Updated reference
    this.curve = Neumorphic.DEFAULT_CURVE, // Updated reference
    this.style,
    this.textStyle,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.drawSurfaceAboveChild = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = NeumorphicTheme.currentTheme(context);
    final NeumorphicStyle style =
        (this.style ?? const NeumorphicStyle()) // Added const
            .copyWithThemeIfNull(theme)
            .applyDisableDepth();

    return _NeumorphicContainer(
      padding: padding, // Removed this. prefix for cleaner code
      textStyle: textStyle,
      drawSurfaceAboveChild: drawSurfaceAboveChild,
      duration: duration,
      style: style,
      curve: curve,
      margin: margin,
      child: child,
    );
  }
}

class _NeumorphicContainer extends StatelessWidget {
  final NeumorphicStyle style;
  final TextStyle? textStyle;
  final Widget? child;
  final EdgeInsets margin;
  final Duration duration;
  final Curve curve;
  final bool drawSurfaceAboveChild;
  final EdgeInsets padding;

  const _NeumorphicContainer({
    // Added const constructor
    super.key, // Updated to use super parameter
    this.child,
    this.textStyle,
    required this.padding,
    required this.margin,
    required this.duration,
    required this.curve,
    required this.style,
    required this.drawSurfaceAboveChild,
  });

  @override
  Widget build(BuildContext context) {
    final shape = style.boxShape ??
        const NeumorphicBoxShape.rect(); // Added const and removed this.

    return DefaultTextStyle(
      style: textStyle ??
          material.Theme.of(context).textTheme.bodyMedium!, // Removed this.
      child: AnimatedContainer(
        margin: margin, // Removed this.
        duration: duration, // Removed this.
        curve: curve, // Removed this.
        decoration: NeumorphicDecoration(
          isForeground: false,
          renderingByPath: shape.customShapePathProvider.oneGradientPerPath,
          splitBackgroundForeground: drawSurfaceAboveChild, // Removed this.
          style: style, // Removed this.
          shape: shape,
        ),
        foregroundDecoration: NeumorphicDecoration(
          isForeground: true,
          renderingByPath: shape.customShapePathProvider.oneGradientPerPath,
          splitBackgroundForeground: drawSurfaceAboveChild, // Removed this.
          style: style, // Removed this.
          shape: shape,
        ),
        child: NeumorphicBoxShapeClipper(
          shape: shape,
          child: Padding(
            padding: padding, // Removed this.
            child: child, // Removed this.
          ),
        ),
      ),
    );
  }
}
