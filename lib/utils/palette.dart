part of '../aio.dart';

class Palette {
  Palette({
    required this.primarySwatch,
    Color? neutralColor,
    Color? neutralColorDark,
    Color? primaryColor,
    Color? secondaryColor,
    Color? backgroundColor,
    Color? surfaceColor,
  }) {
    assert(_checkSwatch(primarySwatch));

    this.neutralColor = neutralColor ?? primarySwatch[50]!;
    this.neutralColorDark = neutralColorDark ?? primarySwatch[900]!;
    this.primaryColor = primaryColor ?? primarySwatch[500]!;
    this.secondaryColor = primarySwatch[300]!;
    this.backgroundColor = backgroundColor ?? primarySwatch[50]!;
    this.surfaceColor = surfaceColor ?? primarySwatch[100]!;
  }

  final ColorSwatch<int> primarySwatch;

  late final Color neutralColor; // primarySwatch[50]
  late final Color neutralColorDark; // primarySwatch[900]
  late final Color primaryColor; // primarySwatch[500]
  late final Color secondaryColor; // primarySwatch[300]
  late final Color backgroundColor; // primarySwatch[50]
  late final Color surfaceColor; // primarySwatch[100]

  bool _checkSwatch(ColorSwatch<int>? swatch) {
    if (swatch == null) return true;
    return _swatchValues.every((value) => swatch[value] != null);
  }
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
