part of '../aio.dart';

/// A container for a page layout.
/// If [child] is provided, it will be used as the page layout.
/// If [pageLayout] is provided, it will be used as the page layout.
class PageContainer extends StatelessWidget {
  PageContainer({
    super.key,
    this.child,
    this.pageLayout,
    this.backgroundColor,
    this.background,
    this.usePadding = true,
    this.useSafeArea = true,
  }) {
    assert(child != null || pageLayout != null);
  }

  final Widget? child;
  final PageLayout? pageLayout;
  final Color? backgroundColor;
  final Widget? background;

  final bool usePadding;
  final bool useSafeArea;

  bool get hasLayout => pageLayout != null;

  @override
  Widget build(BuildContext context) {
    final Widget child = pageLayout ?? this.child!;
    Widget widget = _withSafeArea(child);

    return Container(
      padding: usePadding && !hasLayout ? const EdgeInsets.all(32.0) : null,
      color: backgroundColor ?? App().colorPalette.backgroundColor,
      child: _withBackground(widget),
    );
  }

  Widget _withSafeArea(Widget child) {
    return useSafeArea ? SafeArea(child: child) : child;
  }

  Widget _withBackground(Widget child) {
    return background != null
        ? Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: background!,
              ),
              child,
            ],
          )
        : child;
  }
}
