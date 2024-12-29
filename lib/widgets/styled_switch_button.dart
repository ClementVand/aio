part of '../aio.dart';

/// A styled switch button.
///
/// The left side of the button is the `off` state and the right side is
/// the `on` state.
class StyledSwitchButton extends StatefulWidget {
  const StyledSwitchButton({
    super.key,
    required this.labelOn,
    required this.labelOff,
    required this.onSwitch,
    this.value = false,
  });

  final String labelOn;
  final String labelOff;
  final void Function(bool) onSwitch;
  final bool value;

  @override
  State<StyledSwitchButton> createState() => _StyledSwitchButtonState();
}

class _StyledSwitchButtonState extends State<StyledSwitchButton> {
  late bool _value = widget.value;

  void _switchValue() {
    setState(() {
      _value = !_value;
    });
    widget.onSwitch(_value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _switchValue,
      child: Container(
        height: 54,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: App().colorPalette.surfaceColor,
          borderRadius: BorderRadius.circular(32),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: _value ? constraints.maxWidth / 2 : 0,
                child: Container(
                  width: constraints.maxWidth / 2,
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(
                    color: App().colorPalette.primaryColor,
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
              ),
              Row(
                children: [
                  _buildSwitchButton(widget.labelOff, !_value),
                  _buildSwitchButton(widget.labelOn, _value),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSwitchButton(String label, bool value) {
    return Expanded(
      child: Center(
        child: StyledText(
          label,
          format: TextFormat.sSemiBold,
          color: value ? App().colorPalette.neutralColor : App().colorPalette.neutralColorDark.withOpacity(0.5),
        ),
      ),
    );
  }
}
