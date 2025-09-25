import 'package:flutter/material.dart';

enum ButtonType {
  elevated,
  outlined,
  text,
  icon,
  floating,
}

class CustomButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final ButtonType type;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final Size? iconSize;

  const CustomButton({
    super.key,
    this.text,
    this.icon,
    this.onPressed,
    this.type = ButtonType.elevated,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.elevated:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
          ),
          child: _buildButtonChild(),
        );

      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor,
            padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
          ),
          child: _buildButtonChild(),
        );

      case ButtonType.text:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor,
            padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
          ),
          child: _buildButtonChild(),
        );

      case ButtonType.icon:
        return Container(
          alignment: Alignment.center,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon ?? Icons.star),
            iconSize: iconSize?.width ?? 48,
            style: IconButton.styleFrom(
              backgroundColor: backgroundColor ?? Colors.blue[100],
              padding: padding ?? const EdgeInsets.all(16),
            ),
          ),
        );

      case ButtonType.floating:
        return FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: backgroundColor ?? Colors.blue,
          child: Icon(
            icon ?? Icons.add,
            color: foregroundColor ?? Colors.white,
          ),
        );
    }
  }

  Widget _buildButtonChild() {
    if (icon != null && text != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(text!),
        ],
      );
    } else if (icon != null) {
      return Icon(icon);
    } else {
      return Text(text ?? '');
    }
  }
}

class ButtonGroup extends StatelessWidget {
  final List<CustomButton> buttons;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const ButtonGroup({
    super.key,
    required this.buttons,
    this.direction = Axis.vertical,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.vertical) {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: buttons
            .map((button) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: button,
                ))
            .toList(),
      );
    } else {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: buttons
            .map((button) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: button,
                ))
            .toList(),
      );
    }
  }
}