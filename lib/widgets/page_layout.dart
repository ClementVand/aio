part of '../aio.dart';

class PageLayout extends StatefulWidget {
  PageLayout({
    super.key,
    required this.child,
    this.header = const PageHeader(title: "Untitled Page"),
    this.topWidget,
    this.topWidgetBreakpoint = 0.0,
    this.topWidgetSize,
    this.floatingBottomWidget,
    this.floatingBottomWidgetSize = 0.0,
    this.bottomSafeArea = true,
    this.scrollController,
  }) {
    assert(topWidgetBreakpoint >= 0.0, "Top widget breakpoint must be greater or equal to 0.0");

    if (topWidget != null) {
      assert(topWidgetSize != null && topWidgetSize! >= 0, "Top widget size must be greater than 0");
    }
  }

  /// The content of the page.
  final Widget child;

  /// The header of the page.
  final PageHeader header;

  /// SafeArea bottom activated ?
  final bool bottomSafeArea;

  /// The top widget that will be displayed when the scroll reaches the
  /// breakpoint. If the breakpoint is 0.0, the widget will be displayed.
  final Widget? topWidget;

  /// The breakpoint at which the top widget will be displayed.
  final double topWidgetBreakpoint;

  final double? topWidgetSize;

  /// The bottom widget that will be displayed stacked on top of the content of
  /// the page at the bottom.
  final Widget? floatingBottomWidget;

  final double floatingBottomWidgetSize;

  final ScrollController? scrollController;

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController = widget.scrollController ?? ScrollController();
  late final AnimationController _opacityController;

  bool _showTopWidget = false;
  bool _shrinkContent = false;

  @override
  void initState() {
    super.initState();

    _opacityController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // If the breakpoint is 0.0, the top widget will be displayed.
    if (widget.topWidgetBreakpoint == 0) {
      _showTopWidget = true;
      _opacityController.forward();
      return;
    }

    _scrollController.addListener(_onOpacityListenerCall);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.removeListener(_onOpacityListenerCall);
      _scrollController.dispose();
    }
    _opacityController.dispose();
    super.dispose();
  }

  void _onOpacityListenerCall() {
    if (!mounted) return;
    if (!_showTopWidget && _scrollController.offset >= widget.topWidgetBreakpoint) {
      setState(() {
        _showTopWidget = true;
        _shrinkContent = true;
        _opacityController.forward();
      });
    } else if (_showTopWidget && _scrollController.offset < widget.topWidgetBreakpoint) {
      setState(() {
        _showTopWidget = false;
        _opacityController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double headerSize = widget.header.isHidden ? 0 : 56;
    double topWidgetSize = widget.topWidgetSize ?? 0;

    return LayoutBuilder(builder: (context, constraints) {
      double childHeight = constraints.maxHeight - headerSize;
      childHeight = childHeight - (_shrinkContent ? topWidgetSize : 0);
      childHeight = childHeight - (widget.floatingBottomWidgetSize != 0 ? widget.floatingBottomWidgetSize + 16: 0);

      return Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              _buildHeader(),
              AnimatedSize(
                duration: const Duration(milliseconds: 700),
                curve: Curves.fastOutSlowIn,
                onEnd: () => setState(() {
                  if (!_showTopWidget) _shrinkContent = false;
                }),
                child: SizedBox(
                  height: _showTopWidget ? widget.topWidgetSize : 0,
                  child: FadeTransition(
                    opacity: _opacityController,
                    child: widget.topWidget,
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn,
                child: SizedBox(
                  height: childHeight,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: childHeight, // Set the minimum height to the container height
                      ),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (widget.floatingBottomWidget != null)
            Positioned(
              bottom: 16.0 + (widget.bottomSafeArea == false ? MediaQuery.of(context).padding.bottom : 0.0),
              child: widget.floatingBottomWidget!,
            ),
        ],
      );
    });
  }

  Widget _buildHeader() {
    if (widget.header.isHidden) return const SizedBox();

    bool showBackButton = widget.header.hasBackButton && context.canPop();

    return Container(
      height: widget.header.height,
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: App().colorPalette.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBackButton)
            GestureDetector(
              onTap: widget.header.backButtonCallback ?? Navigator.of(context).pop,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                ),
                child: widget.header.leading ??
                    Icon(
                      Icons.chevron_left,
                      color: App().colorPalette.iconColor.defaultColor,
                    ),
              ),
            ),
          if (!showBackButton) const SizedBox(width: 40),
          StyledText(
            widget.header.title,
            format: TextFormat.mSemibold,
          ),
          if (widget.header.trailing != null) widget.header.trailing!,
          if (widget.header.trailing == null) const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class PageHeader {
  const PageHeader({
    required this.title,
    this.hasBackButton = true,
    this.backButtonCallback,
    this.leading,
    this.trailing,
    this.height = 56,
  }) : isHidden = false;

  PageHeader.hidden()
      : title = "",
        hasBackButton = false,
        backButtonCallback = null,
        leading = null,
        trailing = null,
        height = 56,
        isHidden = true;

  final String title;

  /// If true, a back button will be displayed on the left side of the header.
  /// The button won't be displayed if the page is the first page in the navigation stack.
  final bool hasBackButton;

  /// The callback that will be called when the back button is pressed.
  /// If not provided, the default behavior is to pop the current page.
  final VoidCallback? backButtonCallback;

  /// The leading widget that will be displayed on the left side of the header.
  /// It will be displayed instead of the back button if provided.
  final Widget? leading;

  /// The trailing widget that will be displayed on the right side of the header.
  final Widget? trailing;

  final double height;

  /// If true, the header won't be displayed.
  /// Use [PageHeader.hidden] to hide the header.
  final bool isHidden;
}
