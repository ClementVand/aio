part of '../aio.dart';

class ColorPalette {
  ColorPalette({
    required this.primarySwatch,
    Color? neutralColor,
    Color? neutralColorDark,
    Color? primaryColor,
    Color? secondaryColor,
    Color? backgroundColor,
    Color? surfaceColor,
    ColorState? iconColor,
  }) {
    assert(_checkSwatch(primarySwatch));

    this.neutralColor = neutralColor ?? primarySwatch[50]!;
    this.neutralColorDark = neutralColorDark ?? primarySwatch[900]!;
    this.primaryColor = primaryColor ?? primarySwatch[500]!;
    this.secondaryColor = primarySwatch[300]!;
    this.backgroundColor = backgroundColor ?? primarySwatch[50]!;
    this.surfaceColor = surfaceColor ?? primarySwatch[100]!;

    this.iconColor = iconColor ??
        ColorState(
          defaultColor: primarySwatch[100]!,
          selectedColor: primarySwatch[500]!,
        );
  }

  final ColorSwatch<int> primarySwatch;

  late final Color neutralColor; // primarySwatch[50]
  late final Color neutralColorDark; // primarySwatch[900]
  late final Color primaryColor; // primarySwatch[500]
  late final Color secondaryColor; // primarySwatch[300]
  late final Color backgroundColor; // primarySwatch[50]
  late final Color surfaceColor; // primarySwatch[100]

  late final ColorState iconColor; // primarySwatch[100] and primarySwatch[500]

  bool _checkSwatch(ColorSwatch<int>? swatch) {
    if (swatch == null) return true;
    return _swatchValues.every((value) => swatch[value] != null);
  }
}

/// An object containing different colors for the same object with
/// different states:
/// - `default` - The default color of the object.
/// - `selected` - The color of the object when it is selected.
class ColorState {
  const ColorState({
    required this.defaultColor,
    required this.selectedColor,
  });

  final Color defaultColor;
  final Color selectedColor;
}

const List<int> _swatchValues = [
  50,
  100,
  200,
  300,
  400,
  500,
  600,
  700,
  800,
  900,
];
