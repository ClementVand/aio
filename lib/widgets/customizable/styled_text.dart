part of '../../aio.dart';

/// A styled text widget.
///
/// This widget is used to display text with a specific style.
/// It provides a static method to get the style of a specific format.
/// Useful when using [RichText] or [TextSpan] to unify the style texts.
class StyledText extends StatelessWidget {
  StyledText(
    this.text, {
    super.key,
    required this.format,
    this.align = TextAlign.left,
    Color? color,
  }) {
    this.color = color ?? App().colorPalette.neutralColorDark;
  }

  final String text;
  final TextFormat format;
  final TextAlign align;
  late final Color? color;

  static TextStyle getStyle(TextFormat format, [Color color = Colors.black]) =>
      _textStyleMap[format]!.copyWith(color: color);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = getStyle(format, color!);

    return Text(
      text,
      style: textStyle,
      textAlign: align,
    );
  }
}

enum TextFormat {
  xlSemibold,
  mSemibold,
  mMedium,
  sSemiBold,
  xsBold,
  xsMedium,
}

final Map<TextFormat, TextStyle> _textStyleMap = {
  TextFormat.xlSemibold: const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
  ),
  TextFormat.mSemibold: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),
  TextFormat.mMedium: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  ),
  TextFormat.sSemiBold: const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
  ),
  TextFormat.xsBold: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  ),
  TextFormat.xsMedium: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
};
