part of '../aio.dart';

class PagePlaceholder extends StatelessWidget {
  const PagePlaceholder({
    super.key,
    required this.label,
    this.onButtonPressed,
  });

  final String label;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: onButtonPressed == null
            ? Text(label)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label),
                  ElevatedButton(
                    onPressed: onButtonPressed,
                    child: const Text("Click me"),
                  ),
                ],
              ),
      ),
    );
  }
}
