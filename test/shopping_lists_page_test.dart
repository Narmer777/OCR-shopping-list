import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ocr_shopping_list/features/shopping_lists/presentation/shopping_list_card.dart';
import 'package:ocr_shopping_list/features/shopping_lists/presentation/shopping_lists_page.dart';
import 'package:ocr_shopping_list/widgets/app_bottom_navigation_bar.dart';

Widget buildPage(List<String> titles) {
  return MaterialApp(
    home: Scaffold(
      body: ShoppingListsPage(listTitles: titles),
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (_) {},
      ),
    ),
  );
}

void main() {
  testWidgets('An empty collection shows the empty state and navigation', (
    tester,
  ) async {
    await tester.pumpWidget(buildPage(const []));

    expect(find.text('Мои списки', findRichText: true), findsOneWidget);
    expect(find.text('Пока нет списков покупок'), findsOneWidget);
    expect(find.byType(ShoppingListCard), findsNothing);
    expect(find.text('СПИСКИ'), findsOneWidget);
  });

  testWidgets('A long collection scrolls while navigation stays visible', (
    tester,
  ) async {
    final titles = List.generate(30, (index) => 'Покупки №${index + 1}');
    await tester.pumpWidget(buildPage(titles));

    expect(find.text(titles.first), findsOneWidget);
    expect(find.text(titles.last), findsNothing);

    await tester.scrollUntilVisible(find.text(titles.last), 300);
    await tester.pumpAndSettle();
    await tester.tap(find.text(titles.last));
    await tester.pumpAndSettle();

    expect(find.text(titles.last), findsOneWidget);
    expect(find.text('Мои списки', findRichText: true), findsOneWidget);
    expect(find.text('СПИСКИ').hitTestable(), findsOneWidget);
    expect(find.text('СКАНИРОВАТЬ').hitTestable(), findsOneWidget);
    expect(find.text('СТАТИСТИКА').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Long titles wrap on a narrow screen with enlarged text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    const title = 'Продукты и товары для дома на следующую неделю';
    await tester.pumpWidget(buildPage(const [title]));

    // The card can be taller than the viewport at this text size.
    await tester.tapAt(
      tester.getTopLeft(find.byType(ShoppingListCard)) + const Offset(24, 24),
    );
    await tester.pumpAndSettle();

    expect(find.text(title), findsOneWidget);
    expect(find.text('Пока нет списков покупок'), findsNothing);
    expect(find.text('СПИСКИ').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
