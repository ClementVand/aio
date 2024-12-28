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
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label),
            if (onButtonPressed != null) ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onButtonPressed,
                child: const Text("Click me"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
