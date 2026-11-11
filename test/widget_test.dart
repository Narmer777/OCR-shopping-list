import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import 'package:ocr_shopping_list/main.dart';

void main() {
  testWidgets('Lists is selected by default and navigation switches sections', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byKey(const ValueKey('lists-page')), findsOneWidget);
    expect(find.byIcon(PhosphorIconsFill.listChecks), findsOneWidget);
    expect(find.text('Мои списки', findRichText: true), findsOneWidget);
    expect(find.text('Продукты на неделю'), findsOneWidget);

    await tester.tap(find.text('Продукты на неделю'));
    await tester.pumpAndSettle();

    expect(find.text('Мои списки', findRichText: true), findsOneWidget);
    expect(find.text('СПИСКИ'), findsOneWidget);

    for (final section in [
      (label: 'Сканировать', page: 'scan-page', icon: PhosphorIconsFill.camera),
      (
        label: 'Статистика',
        page: 'statistics-page',
        icon: PhosphorIconsFill.chartBar,
      ),
      (label: 'Списки', page: 'lists-page', icon: PhosphorIconsFill.listChecks),
    ]) {
      await tester.tap(find.text(section.label.toUpperCase()));
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey(section.page)), findsOneWidget);
      expect(find.byIcon(section.icon), findsOneWidget);
      expect(find.text('СПИСКИ'), findsOneWidget);
      expect(find.text('СКАНИРОВАТЬ'), findsOneWidget);
      expect(find.text('СТАТИСТИКА'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Navigation fits a narrow screen with enlarged text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('СТАТИСТИКА'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('statistics-page')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
