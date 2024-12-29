part of '../aio.dart';

/// [PageCollection] is a collection of successive pages that the user can navigate through.
///
/// Each page must extend [StatelessCollectionItem] or [StatefulCollectionItem].
/// This allow your page to be able to call the [next] callback.
/// This method tells the [PageCollection] to navigate to the next page.
///
/// [saveInPrefs] is a boolean that determines whether the current page index should be saved in the SharedPreferences.
/// This allow the user to be taken to the correct page when they reopen the app on this specific collection.
///
/// This widget provides a [next] callback that can be used to navigate to the next page.
/// And a [back] callback that can be used to navigate to the previous page.
class PageCollection extends StatefulWidget {
  PageCollection({
    required this.pages,
    required this.onCollectionEnd,
    this.initialPage = 0,
    this.prefsKey,
    this.wrapper,
    this.controller,
    this.onPageChange,
  }) : super(key: controller?._containerKey) {
    if (prefsKey != null) assert(prefsKey?.isNotEmpty == true);
  }

  final List<CollectionItem> pages;
  final void Function(bool forcedQuit) onCollectionEnd;
  final int initialPage;
  final String? prefsKey;

  /// This callback is called while building the page.
  ///
  /// It allows you to wrap the page in a [Widget] of your choice.
  /// For example, you can wrap the page in a [PageContainer] to provide a background image.
  /// e.g. `wrapper: (Widget child) => PageContainer(page: child)`
  final Widget Function(Widget child)? wrapper;

  /// This controller allows the parent widget to use the [onNext] method to navigate to the next page.
  final PageCollectionController? controller;

  /// This callback is called when the user navigates to the next page.
  final VoidCallback? onPageChange;

  @override
  State<PageCollection> createState() => _PageCollectionState();
}

class _PageCollectionState extends State<PageCollection> {
  late final bool _saveInPrefs = widget.prefsKey != null;
  final prefs = App().prefs.I;
  int _selectedIndex = 0;

  /// This boolean ensure that the [widget.onCollectionEnd] callback is called only once.
  bool _collectionEnded = false;

  /// The widget is saved in a variable to avoid rebuilding it, because it
  /// could cause the "late final" variables to be reassigned which throw an error.
  Widget? _child;

  /// If [widget.saveInPrefs] is false, the method returns early.
  /// [previousIndex] is used to store the index of the last page the user was on before closing the app.
  /// This is used to ensure that the user is taken to the correct page when they reopen the app.
  @override
  void initState() {
    super.initState();

    if (!_saveInPrefs || widget.initialPage != 0) {
      setState(() {
        _selectedIndex = widget.initialPage;
      });
      return;
    }

    int previousIndex = prefs.getInt(widget.prefsKey!) ?? 0;
    setState(() {
      _selectedIndex = previousIndex;
      prefs.setInt(widget.prefsKey!, _selectedIndex);
    });
  }

  /// This callback is called when the user submits a page.
  ///
  /// It increments the [_selectedIndex] and saves the new index in the SharedPreferences.
  /// If the user is on the last page, it removes the [prefsKey] key from the SharedPreferences
  /// Then call [onCollectionEnd] with `false` as an argument to indicate that the user completed the collection.
  ///
  /// This method will return early if the collection has already ended. See [_collectionEnded].
  void onNext() {
    if (_collectionEnded) return;

    if (_selectedIndex == widget.pages.length - 1) {
      if (_saveInPrefs) prefs.remove(widget.prefsKey!);
      _collectionEnded = true;
      widget.onCollectionEnd(false);
      return;
    }

    setState(() {
      _child = null;
      _selectedIndex++;

      if (widget.pages[_selectedIndex].properties["showOnce"] ?? false) _selectedIndex++;

      if (!_saveInPrefs) return;
      prefs.setInt(widget.prefsKey!, _selectedIndex);
    });
    if (widget.onPageChange != null) widget.onPageChange!();
  }

  /// This callback is called when the user goes back to the previous page.
  ///
  /// It decrements the [_selectedIndex] and saves the new index in the SharedPreferences.
  void onBack() {
    if (_selectedIndex == 0) return;

    setState(() {
      _child = null;
      _selectedIndex--;

      if (widget.pages[_selectedIndex].properties["showOnce"] ?? false) _selectedIndex--;

      if (!_saveInPrefs) return;

      prefs.setInt(widget.prefsKey!, _selectedIndex);
    });
    if (widget.onPageChange != null) widget.onPageChange!();
  }

  /// This callback is called when the user quits the collection before reaching the last page.
  /// It resets the collection index from the SharedPreferences.
  ///
  /// [onCollectionEnd] is called with `true` as an argument to indicate that the user quit the collection.
  ///
  /// This method will return early if the collection has already ended. See [_collectionEnded].
  void onQuit() {
    if (_collectionEnded) return;

    _collectionEnded = true;
    widget.onCollectionEnd(true);

    if (!_saveInPrefs) return;
    prefs.remove(widget.prefsKey!);
  }

  @override
  Widget build(BuildContext context) {
    if (_child != null) return _child!;

    CollectionItem currentPage = widget.pages[_selectedIndex];

    currentPage._callbacks[0] = onBack;
    currentPage._callbacks[1] = onNext;
    currentPage._callbacks[2] = onQuit;

    if (currentPage.properties["showOneTime"] ?? false) {
      currentPage.properties["showOnce"] = true;
    }

    if (widget.wrapper != null) {
      _child = widget.wrapper!(currentPage as Widget);
    } else {
      _child = currentPage as Widget;
    }

    return _child!;
  }
}

/// [CollectionItem] is a mixin class that provides callbacks.
/// If you want to add a new method that can be called from the page, you can use the following pattern:
///
/// mixin ExtendedCollectionItem on CollectionItem {
///   late final void Function()? newMethod;
/// }
///
/// abstract class StatelessExtendedCollectionItem extends StatelessCollectionItem with ExtendedCollectionItem {
///   StatelessExtendedCollectionItem({super.key});
/// }
///
/// abstract class StatefulExtendedCollectionItem extends StatefulCollectionItem with ExtendedCollectionItem {
///   StatefulExtendedCollectionItem({super.key});
/// }
///
///
/// This way, from your page, you can call `newMethod`.
///
/// TODO: Need update
/// IMPORTANT: You must set the `newMethod` before or while building the [PageCollection].
/// By doing for example in the initState method of the Widget that contains the [PageCollection]:
/// YourPage()..newMethod = () => print("Hello");
///
/// Or by using the [PageCollection.wrapper] callback.
///
/// Otherwise, you will get a runtime error when calling it in the page.
mixin class CollectionItem {
  final Map<int, void Function()> _callbacks = {};

  void back() => _callbacks[0]!();

  void next() => _callbacks[1]!();

  void quit() => _callbacks[2]!();

  // TODO: Convert to a Map<Property, dynamic>
  // Property is an enum
  // Add a setter to properties: setProperty(Property property, dynamic value) value default to true
  final Map<String, bool> properties = {};
}

/// [StatelessCollectionItem] is a [StatelessWidget] that implements [CollectionItem].
abstract class StatelessCollectionItem extends StatelessWidget with CollectionItem {
  StatelessCollectionItem({super.key});
}

/// [StatefulCollectionItem] is a [StatefulWidget] that implements [CollectionItem].
abstract class StatefulCollectionItem extends StatefulWidget with CollectionItem {
  StatefulCollectionItem({super.key});
}

/// [CollectionItemWrapper] is a [StatelessCollectionItem] that wraps a [Widget].
/// This is useful when you want to use any [Widget] as a page in the [PageCollection].
class CollectionItemWrapper extends StatelessCollectionItem {
  CollectionItemWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// [PageCollectionController] is a controller class that provides a [next], [back], and [quit] method.
class PageCollectionController {
  PageCollectionController();

  final GlobalKey<_PageCollectionState> _containerKey = GlobalKey();

  void back() {
    _PageCollectionState? context = _containerKey.currentState;
    if (context != null) context.onBack();
  }

  void next() {
    _PageCollectionState? context = _containerKey.currentState;
    if (context != null) context.onNext();
  }

  void quit() {
    _PageCollectionState? context = _containerKey.currentState;
    if (context != null) context.onQuit();
  }
}
