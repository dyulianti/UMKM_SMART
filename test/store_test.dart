import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:umkm_smart_assistant/main.dart';

void main() {
  final now = DateTime(2026, 10, 17, 14, 30);
  late UmkmStore store;
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    store = UmkmStore(clock: () => now);
  });
  tearDown(() async {
    await store.saved;
    store.dispose();
  });

  test(
    'checkout records several products and decrements stock atomically',
    () async {
      final originalCount = store.sales.length;
      final sale = store.checkout({'p1': 2, 'p2': 3}, 'QRIS')!;
      expect(sale.total, 95000);
      expect(sale.costTotal, 57000);
      expect(sale.quantity, 5);
      expect(sale.items.length, 2);
      expect(store.productById('p1')!.stock, 22);
      expect(store.productById('p2')!.stock, 1);
      expect(store.sales.length, originalCount + 1);
      expect(store.lowStock.any((p) => p.id == 'p2'), isTrue);
    },
  );

  test('insufficient or stale stock never partially changes an order', () {
    final originalCount = store.sales.length;
    expect(store.checkout({'p1': 2, 'p2': 5}, 'Tunai'), isNull);
    expect(store.productById('p1')!.stock, 24);
    expect(store.sales.length, originalCount);
    expect(store.checkout({'missing': 1}, 'QRIS'), isNull);
    expect(store.checkout({'p1': 0}, 'QRIS'), isNull);
    expect(store.checkout({}, 'Tunai'), isNull);
    expect(store.checkout({'p1': 1}, 'invalid'), isNull);
  });

  test(
    'restocking uses current inventory and preserves historical sale prices',
    () {
      final sale = store.checkout({'p1': 1}, 'Tunai')!;
      store.restock('p1', 10);
      store.saveProduct(store.productById('p1')!.copyWith(price: 30000));
      expect(store.productById('p1')!.stock, 33);
      expect(sale.total, 25000);
      store.deleteProduct('p1');
      expect(sale.items.single.name, 'Brownies Cokelat');
      expect(store.sales.contains(sale), isTrue);
    },
  );

  test('period totals exclude earlier dates and future dates', () {
    store.sales.clear();
    store.expenses.clear();
    Sale saleAt(DateTime day) => Sale(
      id: '$day',
      payment: 'Tunai',
      date: day,
      items: const [
        SaleItem(
          productId: 'p1',
          name: 'Produk',
          quantity: 1,
          price: 100000,
          cost: 40000,
        ),
      ],
    );
    store.sales.addAll([
      saleAt(now),
      saleAt(DateTime(2026, 10, 11)),
      saleAt(DateTime(2026, 10, 10)),
      saleAt(DateTime(2026, 9, 30)),
      saleAt(DateTime(2026, 10, 18)),
    ]);
    store.addExpense(
      category: 'Operasional',
      note: 'Biaya',
      amount: 5000,
      date: now,
    );
    expect(store.summary(BusinessPeriod.today).revenue, 100000);
    expect(store.summary(BusinessPeriod.week).revenue, 200000);
    expect(store.summary(BusinessPeriod.month).revenue, 300000);
    expect(store.summary(BusinessPeriod.today).profit, 55000);
  });

  test(
    'serialized saves restore the latest complete state after reopening',
    () async {
      store.setTarget(8000000);
      store.restock('p1', 5);
      final sale = store.checkout({'p1': 2, 'p4': 1}, 'Transfer')!;
      store.addExpense(
        category: 'Transportasi',
        note: 'Kurir',
        amount: 10000,
        date: now,
      );
      await store.saved;
      final reopened = UmkmStore(
        clock: () => now,
        persistence: SharedPreferencesAsync(),
      );
      await reopened.load();
      expect(reopened.loadFailed, isFalse);
      expect(reopened.monthlyTarget, 8000000);
      expect(reopened.productById('p1')!.stock, 27);
      expect(reopened.sales.first.id, sale.id);
      expect(reopened.sales.first.items.length, 2);
      expect(reopened.expenses.first.note, 'Kurir');
      reopened.dispose();
    },
  );

  test('unreadable local data is retained and reported', () async {
    final prefs = SharedPreferencesAsync();
    await prefs.setString(UmkmStore.storageKey, '{broken');
    await store.load();
    expect(store.loadFailed, isTrue);
    expect(await prefs.getString(UmkmStore.storageKey), '{broken');
  });

  test(
    'starting an own business clears demo records and survives restart',
    () async {
      const profile = BusinessProfile(
        businessName: 'Kedai Senja',
        ownerName: 'Rani',
        category: 'Minuman',
        address: 'Bandung',
        phone: '081234567890',
      );
      store.startOwnBusiness(profile);
      await store.saved;
      final reopened = UmkmStore(clock: () => now);
      await reopened.load();
      expect(reopened.isDemo, isFalse);
      expect(reopened.profile.businessName, 'Kedai Senja');
      expect(reopened.products, isEmpty);
      expect(reopened.sales, isEmpty);
      expect(reopened.expenses, isEmpty);
      reopened.dispose();
    },
  );

  test('CSV follows selected period and escapes spreadsheet formulas', () {
    store.sales.clear();
    store.sales.add(
      Sale(
        id: 'test',
        payment: 'QRIS',
        date: now,
        items: const [
          SaleItem(
            productId: 'p1',
            name: '=SUM(1,2)',
            quantity: 1,
            price: 10000,
            cost: 5000,
          ),
        ],
      ),
    );
    store.sales.add(
      Sale(
        id: 'older',
        payment: 'Tunai',
        date: now.subtract(const Duration(days: 1)),
        items: const [
          SaleItem(
            productId: 'p2',
            name: 'Kemarin',
            quantity: 1,
            price: 20000,
            cost: 5000,
          ),
        ],
      ),
    );
    final csv = reportCsv(store, BusinessPeriod.today);
    expect(csv, contains("'=SUM(1,2)"));
    expect(csv, isNot(contains('Kemarin')));
    expect(csv, contains('"Omzet","10000"'));
    expect(csv, contains('"Laba bersih","-20000"'));
  });
}
