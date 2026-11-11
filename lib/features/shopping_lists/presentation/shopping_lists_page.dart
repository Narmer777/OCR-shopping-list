import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import '../../../widgets/app_action_button.dart';
import 'create_shopping_list_dialog.dart';
import 'shopping_list_card.dart';

class ShoppingListsPage extends StatefulWidget {
  const ShoppingListsPage({super.key, required this.initialListTitles});

  final List<String> initialListTitles;

  @override
  State<ShoppingListsPage> createState() => _ShoppingListsPageState();
}

class _ShoppingListsPageState extends State<ShoppingListsPage> {
  late final List<String> _listTitles;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _listTitles = List.of(widget.initialListTitles);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _createShoppingList() async {
    final title = await showDialog<String>(
      context: context,
      builder: (context) => const CreateShoppingListDialog(),
    );

    if (!mounted || title == null) return;

    setState(() => _listTitles.insert(0, title));
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

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
                child: Row(
                  children: [
                    Expanded(
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
                    const SizedBox(width: 12),
                    AppActionButton.icon(
                      label: 'Создать список',
                      icon: PhosphorIconsRegular.plus,
                      onPressed: _createShoppingList,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _listTitles.isEmpty
                  ? Center(
                      child: SingleChildScrollView(
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
                            const SizedBox(height: 24),
                            AppActionButton(
                              label: 'Создать список',
                              icon: PhosphorIconsRegular.plus,
                              isPrimary: true,
                              onPressed: _createShoppingList,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                      itemCount: _listTitles.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) =>
                          ShoppingListCard(title: _listTitles[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
