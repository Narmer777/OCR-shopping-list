import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class ShoppingListCard extends StatefulWidget {
  const ShoppingListCard({super.key, required this.title});

  final String title;

  @override
  State<ShoppingListCard> createState() => _ShoppingListCardState();
}

class _ShoppingListCardState extends State<ShoppingListCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(12);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      transform: Matrix4.translationValues(
        _isPressed ? 1 : 0,
        _isPressed ? 1 : 0,
        0,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.onSurface, width: 2),
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: colors.onSurface,
            offset: _isPressed ? const Offset(1, 1) : const Offset(2, 2),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          // Opening the list's items belongs to the next task.
          onTap: () {},
          onHighlightChanged: (pressed) {
            setState(() => _isPressed = pressed);
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 60),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    PhosphorIconsRegular.listChecks,
                    size: 20,
                    color: colors.onSurface,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 16,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
