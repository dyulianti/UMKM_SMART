import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:umkm_smart_assistant/main.dart';

void main() {
  final now = DateTime(2026, 10, 17, 10, 30);
  late UmkmStore store;
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    store = UmkmStore(clock: () => now);
  });
  tearDown(() => store.dispose());

  Future<void> openApp(
    WidgetTester tester, {
    Size size = const Size(390, 844),
    double textScale = 1,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(UmkmSmartAssistant(store: store));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'mobile dashboard and all navigation tabs render without overflow',
    (tester) async {
      await openApp(tester);
      expect(find.text('Selamat pagi, Dewi.'), findsOneWidget);
      expect(find.text('Ruang demo'), findsOneWidget);
      for (final label in [
        'Produk',
        'Transaksi',
        'Analisis',
        'Usaha',
        'Beranda',
      ]) {
        await tester.tap(
          find.descendant(
            of: find.byType(NavigationBar),
            matching: find.text(label),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets('catalog search and low-stock filter actually change results', (
    tester,
  ) async {
    await openApp(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Produk'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Kopi');
    await tester.pumpAndSettle();
    expect(find.text('Kopi Susu Aren'), findsOneWidget);
    expect(find.text('Brownies Cokelat'), findsNothing);
    await tester.enterText(find.byType(TextField).first, '');
    await tester.tap(find.text('2 stok menipis'));
    await tester.pumpAndSettle();
    expect(find.text('Cookies Butter'), findsOneWidget);
    expect(find.text('Matcha Latte'), findsOneWidget);
    expect(find.text('Kopi Susu Aren'), findsNothing);
  });

  testWidgets('a multi-product sale updates inventory and opens the receipt', (
    tester,
  ) async {
    await openApp(tester);
    final stock = store.productById('p1')!.stock;
    final originalSales = store.sales.length;
    await tester.ensureVisible(find.text('Penjualan').first);
    await tester.tap(find.text('Penjualan').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('add-p1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('add-p2')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tinjau pesanan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('QRIS'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('confirm-sale')));
    await tester.tap(find.byKey(const ValueKey('confirm-sale')));
    await tester.pumpAndSettle();
    expect(find.text('Penjualan berhasil dicatat.'), findsOneWidget);
    expect(store.sales.length, originalSales + 1);
    expect(store.sales.first.items.length, 2);
    expect(store.sales.first.payment, 'QRIS');
    expect(store.productById('p1')!.stock, stock - 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('product form validates and saves an actual product', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(theme: appTheme(), home: ProductFormScreen(store: store)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simpan produk'));
    await tester.pumpAndSettle();
    expect(find.text('Bagian ini perlu diisi'), findsOneWidget);
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Teh Melati');
    await tester.enterText(fields.at(1), '3000');
    await tester.enterText(fields.at(2), '8000');
    await tester.enterText(fields.at(3), '25');
    await tester.enterText(fields.at(4), '5');
    await tester.ensureVisible(find.text('Simpan produk'));
    await tester.tap(find.text('Simpan produk'));
    await tester.pumpAndSettle();
    expect(store.products.last.name, 'Teh Melati');
    expect(store.products.last.price, 8000);
    expect(tester.takeException(), isNull);
  });

  testWidgets('small phones and larger text retain usable layouts', (
    tester,
  ) async {
    await openApp(tester, size: const Size(320, 740), textScale: 1.2);
    for (final label in [
      'Beranda',
      'Produk',
      'Transaksi',
      'Analisis',
      'Usaha',
    ]) {
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(label),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
    tester.view.physicalSize = const Size(1280, 700);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop uses sidebar and all tabs render without overflow', (
    tester,
  ) async {
    await openApp(tester, size: const Size(1440, 1000));
    expect(find.byType(NavigationBar), findsNothing);
    for (final label in [
      'Produk',
      'Transaksi',
      'Analisis',
      'Usaha',
      'Beranda',
    ]) {
      await tester.tap(find.widgetWithText(ListTile, label).first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('empty own-business workspace remains usable', (tester) async {
    store.startOwnBusiness(
      const BusinessProfile(
        businessName: 'Kedai Rani',
        ownerName: 'Rani',
        category: 'Minuman',
        address: 'Bandung',
        phone: '08123456789',
      ),
    );
    await openApp(tester);
    expect(find.text('Ruang demo'), findsNothing);
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Produk'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Produk pertamamu menanti.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  if (const bool.fromEnvironment('PREVIEW')) {
    testWidgets('render review previews', (tester) async {
      final iconLoader = FontLoader('MaterialIcons')
        ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
      await iconLoader.load();
      final fonts = {
        'Roboto': [
          'C:/Windows/Fonts/arial.ttf',
          'C:/Windows/Fonts/arialbd.ttf',
        ],
      };
      for (final entry in fonts.entries) {
        final loader = FontLoader(entry.key);
        for (final path in entry.value) {
          loader.addFont(
            Future.value(ByteData.sublistView(File(path).readAsBytesSync())),
          );
        }
        await loader.load();
      }
      await openApp(tester, size: const Size(1440, 1100));
      await expectLater(
        find.byType(UmkmSmartAssistant),
        matchesGoldenFile('../build/previews/dashboard-desktop.png'),
      );
      await tester.tap(find.widgetWithText(ListTile, 'Produk').first);
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(UmkmSmartAssistant),
        matchesGoldenFile('../build/previews/catalog-desktop.png'),
      );
      await tester.pumpWidget(const SizedBox());
      await openApp(tester);
      await expectLater(
        find.byType(UmkmSmartAssistant),
        matchesGoldenFile('../build/previews/dashboard-mobile.png'),
      );
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('Produk'),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(UmkmSmartAssistant),
        matchesGoldenFile('../build/previews/catalog-mobile.png'),
      );
    });
  }
}
