import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _destinations = [
    (
      label: 'Списки',
      icon: PhosphorIconsRegular.listChecks,
      selectedIcon: PhosphorIconsFill.listChecks,
    ),
    (
      label: 'Сканировать',
      icon: PhosphorIconsRegular.camera,
      selectedIcon: PhosphorIconsFill.camera,
    ),
    (
      label: 'Статистика',
      icon: PhosphorIconsRegular.chartBar,
      selectedIcon: PhosphorIconsFill.chartBar,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.onSurface, width: 2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < _destinations.length; index++)
                  Expanded(
                    child: Semantics(
                      label: _destinations[index].label,
                      button: true,
                      selected: index == selectedIndex,
                      excludeSemantics: true,
                      onTap: () => onDestinationSelected(index),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => onDestinationSelected(index),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 160),
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: index == selectedIndex
                                      ? colors.onSurface
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: index == selectedIndex
                                      ? [
                                          BoxShadow(
                                            color: colors.onSurface,
                                            offset: const Offset(2, 2),
                                          ),
                                        ]
                                      : const [],
                                ),
                                child: Icon(
                                  index == selectedIndex
                                      ? _destinations[index].selectedIcon
                                      : _destinations[index].icon,
                                  size: 24,
                                  color: index == selectedIndex
                                      ? colors.surface
                                      : colors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _destinations[index].label.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  height: 1.2,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  color: index == selectedIndex
                                      ? colors.onSurface
                                      : colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
