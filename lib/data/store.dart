import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessProfile {
  final String businessName, ownerName, category, address, phone;
  const BusinessProfile({
    required this.businessName,
    required this.ownerName,
    required this.category,
    required this.address,
    required this.phone,
  });
  Map<String, dynamic> toJson() => {
    'businessName': businessName,
    'ownerName': ownerName,
    'category': category,
    'address': address,
    'phone': phone,
  };
  factory BusinessProfile.fromJson(Map<String, dynamic> j) => BusinessProfile(
    businessName: j['businessName'],
    ownerName: j['ownerName'],
    category: j['category'],
    address: j['address'],
    phone: j['phone'],
  );
}

class Product {
  final String id, name, category;
  final int cost, price, stock, minStock;
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.cost,
    required this.price,
    required this.stock,
    required this.minStock,
  });
  Product copyWith({
    String? name,
    String? category,
    int? cost,
    int? price,
    int? stock,
    int? minStock,
  }) => Product(
    id: id,
    name: name ?? this.name,
    category: category ?? this.category,
    cost: cost ?? this.cost,
    price: price ?? this.price,
    stock: stock ?? this.stock,
    minStock: minStock ?? this.minStock,
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'cost': cost,
    'price': price,
    'stock': stock,
    'minStock': minStock,
  };
  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'],
    name: j['name'],
    category: j['category'],
    cost: j['cost'],
    price: j['price'],
    stock: j['stock'],
    minStock: j['minStock'],
  );
}

class SaleItem {
  final String productId, name;
  final int quantity, price, cost;
  const SaleItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.cost,
  });
  int get total => price * quantity;
  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'quantity': quantity,
    'price': price,
    'cost': cost,
  };
  factory SaleItem.fromJson(Map<String, dynamic> j) => SaleItem(
    productId: j['productId'],
    name: j['name'],
    quantity: j['quantity'],
    price: j['price'],
    cost: j['cost'],
  );
}

class Sale {
  final String id, payment;
  final DateTime date;
  final List<SaleItem> items;
  Sale({
    required this.id,
    required this.payment,
    required this.date,
    required List<SaleItem> items,
  }) : items = List.unmodifiable(items);
  int get total => items.fold(0, (sum, item) => sum + item.total);
  int get costTotal =>
      items.fold(0, (sum, item) => sum + item.cost * item.quantity);
  int get quantity => items.fold(0, (sum, item) => sum + item.quantity);
  String get productName => items.map((e) => e.name).join(', ');
  Map<String, dynamic> toJson() => {
    'id': id,
    'payment': payment,
    'date': date.toIso8601String(),
    'items': items.map((e) => e.toJson()).toList(),
  };
  factory Sale.fromJson(Map<String, dynamic> j) => Sale(
    id: j['id'],
    payment: j['payment'],
    date: DateTime.parse(j['date']),
    items: (j['items'] as List).map((e) => SaleItem.fromJson(e)).toList(),
  );
}

class Expense {
  final String id, category, note;
  final int amount;
  final DateTime date;
  const Expense({
    required this.id,
    required this.category,
    required this.note,
    required this.amount,
    required this.date,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'note': note,
    'amount': amount,
    'date': date.toIso8601String(),
  };
  factory Expense.fromJson(Map<String, dynamic> j) => Expense(
    id: j['id'],
    category: j['category'],
    note: j['note'],
    amount: j['amount'],
    date: DateTime.parse(j['date']),
  );
}

enum BusinessPeriod {
  today('Hari ini'),
  week('7 hari'),
  month('Bulan ini');

  final String label;
  const BusinessPeriod(this.label);
  DateTime start(DateTime now) => switch (this) {
    today => DateTime(now.year, now.month, now.day),
    week => DateTime(now.year, now.month, now.day - 6),
    month => DateTime(now.year, now.month),
  };
  bool includes(DateTime date, DateTime now) =>
      !date.isBefore(start(now)) &&
      date.isBefore(DateTime(now.year, now.month, now.day + 1));
}

class BusinessSummary {
  final List<Sale> sales;
  final List<Expense> expenses;
  BusinessSummary(this.sales, this.expenses);
  int get revenue => sales.fold(0, (s, e) => s + e.total);
  int get costs => sales.fold(0, (s, e) => s + e.costTotal);
  int get spending => expenses.fold(0, (s, e) => s + e.amount);
  int get profit => revenue - costs - spending;
  int get units => sales.fold(0, (s, e) => s + e.quantity);
}

class UmkmStore extends ChangeNotifier {
  static const storageKey = 'ruang_usaha_v1';
  final SharedPreferencesAsync? persistence;
  final DateTime Function() clock;
  bool isDemo = true;
  int monthlyTarget = 5000000;
  String? storageError;
  bool loadFailed = false;
  Future<void> _pending = Future.value();
  bool _disposed = false;
  BusinessProfile profile = const BusinessProfile(
    businessName: 'Kafe Ayem',
    ownerName: 'Dewi Yulianti',
    category: 'Makanan & minuman',
    address: 'Jl. Melati No. 12, Bandung',
    phone: '0812-3456-7890',
  );
  final List<Product> products = [];
  final List<Sale> sales = [];
  final List<Expense> expenses = [];

  UmkmStore({
    this.persistence,
    DateTime Function()? clock,
    bool seedDemo = true,
  }) : clock = clock ?? DateTime.now {
    if (seedDemo) _seed();
  }

  void _seed() {
    products.addAll(const [
      Product(
        id: 'p1',
        name: 'Brownies Cokelat',
        category: 'Makanan Ringan',
        cost: 15000,
        price: 25000,
        stock: 24,
        minStock: 5,
      ),
      Product(
        id: 'p2',
        name: 'Cookies Butter',
        category: 'Makanan Ringan',
        cost: 9000,
        price: 15000,
        stock: 4,
        minStock: 5,
      ),
      Product(
        id: 'p3',
        name: 'Donat Gula',
        category: 'Makanan',
        cost: 5000,
        price: 10000,
        stock: 18,
        minStock: 5,
      ),
      Product(
        id: 'p4',
        name: 'Kopi Susu Aren',
        category: 'Minuman',
        cost: 8000,
        price: 18000,
        stock: 32,
        minStock: 8,
      ),
      Product(
        id: 'p5',
        name: 'Matcha Latte',
        category: 'Minuman',
        cost: 11000,
        price: 23000,
        stock: 3,
        minStock: 5,
      ),
      Product(
        id: 'p6',
        name: 'Croissant Butter',
        category: 'Makanan',
        cost: 12000,
        price: 22000,
        stock: 12,
        minStock: 4,
      ),
    ]);
    final now = clock();
    for (var day = 0; day < 14; day++) {
      for (var n = 0; n < (day == 0 ? 5 : 2 + day % 3); n++) {
        final p = products[(day + n) % products.length];
        sales.add(
          Sale(
            id: 'AY-${1048 - day * 5 - n}',
            payment: ['QRIS', 'Tunai', 'Transfer'][n % 3],
            date: DateTime(
              now.year,
              now.month,
              now.day - day,
              day == 0 ? now.hour : 10 + n,
              day == 0 ? (now.minute - n * 5).clamp(0, 59) : 15,
            ),
            items: [
              SaleItem(
                productId: p.id,
                name: p.name,
                quantity: 2 + (day + n) % 4,
                price: p.price,
                cost: p.cost,
              ),
            ],
          ),
        );
      }
    }
    expenses.addAll([
      Expense(
        id: 'e1',
        category: 'Operasional',
        note: 'Kemasan takeaway',
        amount: 25000,
        date: now,
      ),
      Expense(
        id: 'e2',
        category: 'Operasional',
        note: 'Listrik dan air',
        amount: 65000,
        date: now.subtract(const Duration(days: 2)),
      ),
      Expense(
        id: 'e3',
        category: 'Transportasi',
        note: 'Pengiriman pesanan',
        amount: 20000,
        date: now.subtract(const Duration(days: 4)),
      ),
    ]);
  }

  Future<void> load() async {
    try {
      final raw = await (persistence ?? SharedPreferencesAsync()).getString(
        storageKey,
      );
      if (raw != null) {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        final savedProfile = BusinessProfile.fromJson(j['profile']);
        final savedProducts =
            (j['products'] as List).map((e) => Product.fromJson(e)).toList();
        final savedSales =
            (j['sales'] as List).map((e) => Sale.fromJson(e)).toList();
        final savedExpenses =
            (j['expenses'] as List).map((e) => Expense.fromJson(e)).toList();
        final savedTarget = j['monthlyTarget'] as int;
        final savedDemo = j['isDemo'] as bool;
        profile = savedProfile;
        products
          ..clear()
          ..addAll(savedProducts);
        sales
          ..clear()
          ..addAll(savedSales);
        expenses
          ..clear()
          ..addAll(savedExpenses);
        monthlyTarget = savedTarget;
        isDemo = savedDemo;
      }
      storageError = null;
      loadFailed = false;
    } catch (_) {
      loadFailed = true;
      storageError =
          'Data lokal belum dapat dibaca. Coba buka ulang aplikasi sebelum mengubah data.';
    }
  }

  BusinessSummary summary(BusinessPeriod period) => BusinessSummary(
    sales.where((e) => period.includes(e.date, clock())).toList(),
    expenses.where((e) => period.includes(e.date, clock())).toList(),
  );
  List<Product> get lowStock =>
      products.where((p) => p.stock <= p.minStock).toList();
  Product? productById(String id) {
    for (final p in products) {
      if (p.id == id) return p;
    }
    return null;
  }

  String newId(String prefix) =>
      '$prefix-${clock().microsecondsSinceEpoch}-${sales.length + expenses.length + products.length}';
  Future<void> get saved => _pending;
  void _changed() {
    notifyListeners();
    // Serialize writes so rapid stock changes cannot overwrite newer snapshots.
    final snapshot = jsonEncode({
      'version': 1,
      'isDemo': isDemo,
      'monthlyTarget': monthlyTarget,
      'profile': profile.toJson(),
      'products': products.map((e) => e.toJson()).toList(),
      'sales': sales.map((e) => e.toJson()).toList(),
      'expenses': expenses.map((e) => e.toJson()).toList(),
    });
    _pending = _pending.then((_) async {
      try {
        await (persistence ?? SharedPreferencesAsync()).setString(
          storageKey,
          snapshot,
        );
        if (storageError != null) {
          storageError = null;
          if (!_disposed) notifyListeners();
        }
      } catch (_) {
        storageError =
            'Perubahan belum tersimpan di perangkat. Coba simpan kembali.';
        if (!_disposed) notifyListeners();
      }
    });
  }

  void retrySave() => _changed();
  void updateProfile(BusinessProfile value) {
    profile = value;
    _changed();
  }

  void setTarget(int value) {
    if (value <= 0) return;
    monthlyTarget = value;
    _changed();
  }

  void saveProduct(Product product) {
    if (product.price < 1 ||
        product.cost < 0 ||
        product.stock < 0 ||
        product.minStock < 0 ||
        product.name.trim().isEmpty) {
      return;
    }
    final i = products.indexWhere((e) => e.id == product.id);
    if (i < 0) {
      products.add(product);
    } else {
      products[i] = product;
    }
    _changed();
  }

  void deleteProduct(String id) {
    products.removeWhere((e) => e.id == id);
    _changed();
  }

  void restock(String id, int quantity) {
    final product = productById(id);
    if (product == null || quantity < 1) return;
    saveProduct(product.copyWith(stock: product.stock + quantity));
  }

  Sale? checkout(Map<String, int> cart, String payment) {
    if (cart.isEmpty || !['Tunai', 'QRIS', 'Transfer'].contains(payment)) {
      return null;
    }
    final items = <SaleItem>[];
    for (final entry in cart.entries) {
      final p = productById(entry.key);
      if (p == null || entry.value < 1 || entry.value > p.stock) return null;
      items.add(
        SaleItem(
          productId: p.id,
          name: p.name,
          quantity: entry.value,
          price: p.price,
          cost: p.cost,
        ),
      );
    }
    // Validate all items before changing inventory or recording the sale.
    for (final entry in cart.entries) {
      final i = products.indexWhere((p) => p.id == entry.key);
      products[i] = products[i].copyWith(
        stock: products[i].stock - entry.value,
      );
    }
    final sale = Sale(
      id: newId('TRX'),
      payment: payment,
      date: clock(),
      items: items,
    );
    sales.insert(0, sale);
    _changed();
    return sale;
  }

  void addExpense({
    required String category,
    required String note,
    required int amount,
    required DateTime date,
  }) {
    if (amount < 1 || note.trim().isEmpty) return;
    expenses.insert(
      0,
      Expense(
        id: newId('EXP'),
        category: category,
        note: note,
        amount: amount,
        date: date,
      ),
    );
    expenses.sort((a, b) => b.date.compareTo(a.date));
    _changed();
  }

  void startOwnBusiness(BusinessProfile value) {
    profile = value;
    products.clear();
    sales.clear();
    expenses.clear();
    isDemo = false;
    _changed();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
