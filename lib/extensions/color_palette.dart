part of '../aio.dart';

extension AppColorPalette on App {
  static final _colorPalette = Expando<ColorPalette>();

  ColorPalette get colorPalette {
    if (_colorPalette[this] == null) {
      throw "AppColorPalette not initialized. Set your [colorPalette] in App().run()";
    }

    return _colorPalette[this]!;
  }

  set colorPalette(ColorPalette colorPalette) {
    _colorPalette[this] = colorPalette;
  }
}
