import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import 'shopping_list_card.dart';

class ShoppingListsPage extends StatelessWidget {
  const ShoppingListsPage({super.key, required this.listTitles});

  final List<String> listTitles;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: colors.onSurface, width: 2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Text.rich(
                  TextSpan(
                    text: 'Мои ',
                    children: const [
                      TextSpan(
                        text: 'списки',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    // Lora supplies the Cyrillic serif glyphs absent in Fraunces.
                    fontFamily: 'Lora',
                    fontSize: 30,
                    height: 1.2,
                    letterSpacing: -0.3,
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
                ),
              ),
            ),
            Expanded(
              child: listTitles.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              PhosphorIconsRegular.listChecks,
                              size: 40,
                              color: colors.onSurfaceVariant,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Пока нет списков покупок',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                      itemCount: listTitles.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) =>
                          ShoppingListCard(title: listTitles[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
