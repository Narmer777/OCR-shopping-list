import 'package:flutter/material.dart';

class AppActionButton extends StatefulWidget {
  const AppActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isPrimary = false,
  }) : _iconOnly = false;

  const AppActionButton.icon({
    super.key,
    required this.label,
    required this.onPressed,
    required this.icon,
  }) : assert(icon != null),
       isPrimary = false,
       _iconOnly = true;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
  final bool _iconOnly;

  @override
  State<AppActionButton> createState() => _AppActionButtonState();
}

class _AppActionButtonState extends State<AppActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final enabled = widget.onPressed != null;
    final foreground = !enabled
        ? colors.onSurfaceVariant
        : widget.isPrimary
        ? colors.onPrimary
        : colors.onSurface;
    final radius = BorderRadius.circular(12);

    final button = AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      transform: Matrix4.translationValues(
        _isPressed ? 1 : 0,
        _isPressed ? 1 : 0,
        0,
      ),
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      decoration: BoxDecoration(
        color: !enabled
            ? const Color(0xFFE5E7EB)
            : widget.isPrimary
            ? colors.primary
            : colors.surface,
        border: Border.all(color: colors.onSurface, width: 2),
        borderRadius: radius,
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: colors.onSurface,
                  offset: _isPressed
                      ? const Offset(1, 1)
                      : widget.isPrimary
                      ? const Offset(4, 4)
                      : const Offset(2, 2),
                ),
              ]
            : const [],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: widget.onPressed,
          onHighlightChanged: (pressed) {
            setState(() => _isPressed = pressed);
          },
          child: Padding(
            padding: widget._iconOnly
                ? const EdgeInsets.all(8)
                : const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: widget._iconOnly
                ? Icon(widget.icon, size: 24, color: foreground)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 24, color: foreground),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          widget.label.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: foreground,
                            fontSize: 12,
                            height: 1.3,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.72,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );

    return Semantics(
      label: widget.label,
      button: true,
      enabled: enabled,
      onTap: widget.onPressed,
      excludeSemantics: true,
      child: widget._iconOnly
          ? Tooltip(message: widget.label, child: button)
          : button,
    );
  }
}
