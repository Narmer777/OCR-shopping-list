import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ocr_shopping_list/features/shopping_lists/presentation/create_shopping_list_dialog.dart';
import 'package:ocr_shopping_list/features/shopping_lists/presentation/shopping_lists_page.dart';
import 'package:ocr_shopping_list/main.dart';

Widget buildListsPage(List<String> titles) {
  return MaterialApp(
    home: Scaffold(body: ShoppingListsPage(initialListTitles: titles)),
  );
}

Future<void> openCreateDialog(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Создать список'));
  await tester.pumpAndSettle();
}

Future<void> enterListName(WidgetTester tester, String name) async {
  await tester.enterText(find.byType(TextField), name);
  await tester.pumpAndSettle();
}

void main() {
  final limitCases = [
    (
      description: 'A name of exactly 50 characters can be saved',
      input: List.filled(50, 'А').join(),
      expected: List.filled(50, 'А').join(),
    ),
    (
      description: 'Pasting more than 50 characters truncates the name',
      input: List.filled(51, 'Б').join(),
      expected: List.filled(50, 'Б').join(),
    ),
    (
      description: 'The limit counts whole emoji without splitting them',
      input: List.filled(51, '👨‍👩‍👧‍👦').join(),
      expected: List.filled(50, '👨‍👩‍👧‍👦').join(),
    ),
  ];

  for (final limitCase in limitCases) {
    testWidgets(limitCase.description, (tester) async {
      await tester.pumpWidget(buildListsPage(const []));
      await openCreateDialog(tester);
      await enterListName(tester, limitCase.input);

      final field = tester.widget<TextField>(find.byType(TextField));
      expect(field.controller!.text, limitCase.expected);
      expect(find.text('50/50'), findsOneWidget);

      await tester.tap(find.text('СОЗДАТЬ'));
      await tester.pumpAndSettle();

      expect(find.byType(CreateShoppingListDialog), findsNothing);
      expect(find.text(limitCase.expected), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Creation trims the name and survives switching tabs', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await openCreateDialog(tester);
    await enterListName(tester, '   Покупки к отпуску   ');
    await tester.tap(find.text('СОЗДАТЬ'));
    await tester.pumpAndSettle();

    expect(find.byType(CreateShoppingListDialog), findsNothing);
    expect(find.text('Покупки к отпуску'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Покупки к отпуску')).dy,
      lessThan(tester.getTopLeft(find.text('Продукты на неделю')).dy),
    );

    await tester.tap(find.text('СКАНИРОВАТЬ'));
    await tester.pumpAndSettle();
    expect(find.text('Покупки к отпуску'), findsNothing);

    await tester.tap(find.text('СПИСКИ'));
    await tester.pumpAndSettle();
    expect(find.text('Покупки к отпуску'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Empty and whitespace names cannot be submitted', (tester) async {
    await tester.pumpWidget(buildListsPage(const []));
    await openCreateDialog(tester);

    await tester.tap(find.text('СОЗДАТЬ'));
    await tester.pumpAndSettle();
    expect(find.byType(CreateShoppingListDialog), findsOneWidget);

    await enterListName(tester, '   ');
    await tester.tap(find.text('СОЗДАТЬ'));
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.byType(CreateShoppingListDialog), findsOneWidget);

    await enterListName(tester, 'Для поездки');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.byType(CreateShoppingListDialog), findsNothing);
    expect(find.text('Для поездки'), findsOneWidget);
    expect(find.text('Пока нет списков покупок'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Cancel, back and barrier dismissal do not create a list', (
    tester,
  ) async {
    await tester.pumpWidget(buildListsPage(const []));

    await openCreateDialog(tester);
    await enterListName(tester, 'Отменённый список');
    await tester.tap(find.text('ОТМЕНА'));
    await tester.pumpAndSettle();

    await openCreateDialog(tester);
    await enterListName(tester, 'Отменённый список');
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await openCreateDialog(tester);
    await enterListName(tester, 'Отменённый список');
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(find.byType(CreateShoppingListDialog), findsNothing);
    expect(find.text('Отменённый список'), findsNothing);
    expect(find.text('Пока нет списков покупок'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('The empty-state button creates the first list', (tester) async {
    await tester.pumpWidget(buildListsPage(const []));
    await tester.tap(find.text('СОЗДАТЬ СПИСОК'));
    await tester.pumpAndSettle();
    await enterListName(tester, 'Первый список');
    await tester.tap(find.text('СОЗДАТЬ'));
    await tester.pumpAndSettle();

    expect(find.text('Первый список'), findsOneWidget);
    expect(find.text('Пока нет списков покупок'), findsNothing);
    expect(find.byTooltip('Создать список'), findsOneWidget);
  });

  testWidgets('Creating from a scrolled list reveals the new first card', (
    tester,
  ) async {
    final titles = List.generate(30, (index) => 'Список №${index + 1}');
    await tester.pumpWidget(buildListsPage(titles));
    await tester.scrollUntilVisible(find.text(titles.last), 300);
    await tester.pumpAndSettle();
    await openCreateDialog(tester);
    await enterListName(tester, 'Новый сверху');
    await tester.tap(find.text('СОЗДАТЬ'));
    await tester.pumpAndSettle();

    expect(find.text('Новый сверху').hitTestable(), findsOneWidget);
    expect(find.text(titles.first).hitTestable(), findsOneWidget);
    expect(titles.length, 30);
    expect(titles.first, 'Список №1');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Creation works on a narrow screen with keyboard and large text',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      tester.view.viewInsets = const FakeViewPadding(bottom: 240);
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await tester.pumpWidget(buildListsPage(const []));
      await openCreateDialog(tester);
      await enterListName(tester, 'Список на маленьком экране');
      await tester.ensureVisible(find.text('СОЗДАТЬ'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('СОЗДАТЬ'));
      await tester.pumpAndSettle();

      expect(find.byType(CreateShoppingListDialog), findsNothing);
      expect(find.text('Список на маленьком экране'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
