part of '../aio.dart';

/// A widget that lays out its children in a row or column with optional
/// padding, element spacing and safe area.
///
/// Convenient for evenly spaced layouts.
class AutoLayout extends StatelessWidget {
  const AutoLayout({
    super.key,
    required this.children,
    this.direction = Axis.vertical,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.safeArea = SafeAreaMode.none,
    this.elementSpacing = 0,
    this.padding,
  });

  final List<Widget> children;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  final SafeAreaMode safeArea;
  final double elementSpacing;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return direction == Axis.vertical ? _buildVerticalLayout() : _buildHorizontalLayout();
  }

  Widget _buildVerticalLayout() {
    Widget layout = Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: _buildSpacedChildren(),
    );

    if (safeArea != SafeAreaMode.none) layout = _withSafeArea(layout);
    return padding != null ? _withPadding(layout) : layout;
  }

  Widget _buildHorizontalLayout() {
    Widget layout = Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: _buildSpacedChildren(),
    );

    if (safeArea != SafeAreaMode.none) layout = _withSafeArea(layout);
    return padding != null ? _withPadding(layout) : layout;
  }

  List<Widget> _buildSpacedChildren() {
    final spacedChildren = <Widget>[];

    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i != children.length - 1) {
        spacedChildren.add(
          SizedBox(
            width: direction == Axis.horizontal ? elementSpacing : 0,
            height: direction == Axis.vertical ? elementSpacing : 0,
          ),
        );
      }
    }
    return spacedChildren;
  }

  Widget _withPadding(Widget child) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: child,
    );
  }

  Widget _withSafeArea(Widget child) {
    return SafeArea(
      top: safeArea == SafeAreaMode.top || safeArea == SafeAreaMode.both,
      bottom: safeArea == SafeAreaMode.bottom || safeArea == SafeAreaMode.both,
      child: child,
    );
  }
}

enum SafeAreaMode {
  none,
  top,
  bottom,
  both,
}
