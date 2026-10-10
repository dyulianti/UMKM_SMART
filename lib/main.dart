import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const UmkmSmartAssistant());

const _navy = Color(0xFF17212B);
const _ink = Color(0xFF1F2933);
const _muted = Color(0xFF697586);
const _blue = Color(0xFF2563EB);
const _green = Color(0xFF159B6A);
const _orange = Color(0xFFF59E0B);
const _red = Color(0xFFDC4C64);
const _surface = Color(0xFFF6F8FB);

class UmkmSmartAssistant extends StatefulWidget {
  const UmkmSmartAssistant({super.key});

  @override
  State<UmkmSmartAssistant> createState() => _UmkmSmartAssistantState();
}

class _UmkmSmartAssistantState extends State<UmkmSmartAssistant> {
  final store = UmkmStore();
  AppStage stage = AppStage.splash;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1300), () {
      if (mounted) setState(() => stage = AppStage.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UMKM Smart Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _surface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _blue,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: _ink,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: _ink,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD6DCE4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD6DCE4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _blue, width: 1.5),
          ),
        ),
      ),
      home: switch (stage) {
        AppStage.splash => const SplashScreen(),
        AppStage.login => LoginScreen(
          onLogin: () => setState(() => stage = AppStage.home),
          onRegister: () => setState(() => stage = AppStage.register),
        ),
        AppStage.register => RegisterScreen(
          onRegistered: () => setState(() => stage = AppStage.setup),
          onBack: () => setState(() => stage = AppStage.login),
        ),
        AppStage.setup => BusinessSetupScreen(
          store: store,
          onSaved: () => setState(() => stage = AppStage.home),
        ),
        AppStage.home => MainShell(
          store: store,
          onLogout: () => setState(() => stage = AppStage.login),
        ),
      },
    );
  }
}

enum AppStage { splash, login, register, setup, home }

class BusinessProfile {
  String businessName;
  String ownerName;
  String category;
  String address;
  String phone;

  BusinessProfile({
    required this.businessName,
    required this.ownerName,
    required this.category,
    required this.address,
    required this.phone,
  });
}

class Product {
  final String id;
  final String name;
  final String category;
  final int cost;
  final int price;
  final int stock;
  final int minStock;

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
}

class Sale {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final int total;
  final int costTotal;
  final String payment;
  final DateTime date;

  const Sale({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.total,
    required this.costTotal,
    required this.payment,
    required this.date,
  });
}

class Expense {
  final String id;
  final String category;
  final String note;
  final int amount;
  final DateTime date;

  const Expense({
    required this.id,
    required this.category,
    required this.note,
    required this.amount,
    required this.date,
  });
}

class UmkmStore extends ChangeNotifier {
  BusinessProfile profile = BusinessProfile(
    businessName: 'Kafe Ayem',
    ownerName: 'Dewi Yulianti',
    category: 'Makanan dan minuman',
    address: 'Jl. Melati No. 12',
    phone: '0812-3456-7890',
  );
  final List<Product> products = [
    const Product(
      id: 'p1',
      name: 'Brownies Cokelat',
      category: 'Makanan Ringan',
      cost: 15000,
      price: 25000,
      stock: 20,
      minStock: 5,
    ),
    const Product(
      id: 'p2',
      name: 'Cookies',
      category: 'Makanan Ringan',
      cost: 9000,
      price: 15000,
      stock: 4,
      minStock: 4,
    ),
    const Product(
      id: 'p3',
      name: 'Donat',
      category: 'Makanan',
      cost: 12000,
      price: 20000,
      stock: 15,
      minStock: 5,
    ),
  ];
  final List<Sale> sales = [
    Sale(
      id: 's1',
      productId: 'p1',
      productName: 'Brownies Cokelat',
      quantity: 3,
      total: 75000,
      costTotal: 45000,
      payment: 'Cash',
      date: DateTime.now(),
    ),
    Sale(
      id: 's2',
      productId: 'p2',
      productName: 'Cookies',
      quantity: 2,
      total: 30000,
      costTotal: 18000,
      payment: 'Transfer',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Sale(
      id: 's3',
      productId: 'p3',
      productName: 'Donat',
      quantity: 1,
      total: 20000,
      costTotal: 12000,
      payment: 'Cash',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];
  final List<Expense> expenses = [
    Expense(
      id: 'e1',
      category: 'Operasional',
      note: 'Biaya kemasan',
      amount: 50000,
      date: DateTime.now(),
    ),
    Expense(
      id: 'e2',
      category: 'Bahan Baku',
      note: 'Tepung dan gula',
      amount: 150000,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Expense(
      id: 'e3',
      category: 'Operasional',
      note: 'Gas',
      amount: 20000,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  int get revenue => sales.fold(0, (sum, item) => sum + item.total);
  int get costOfGoods => sales.fold(0, (sum, item) => sum + item.costTotal);
  int get expenseTotal => expenses.fold(0, (sum, item) => sum + item.amount);
  int get profit => revenue - costOfGoods - expenseTotal;
  List<Product> get lowStock =>
      products.where((p) => p.stock <= p.minStock).toList();
  Product? productById(String id) =>
      products.where((item) => item.id == id).firstOrNull;

  void updateProfile(BusinessProfile value) {
    profile = value;
    notifyListeners();
  }

  void saveProduct(Product product) {
    final index = products.indexWhere((item) => item.id == product.id);
    if (index == -1) {
      products.add(product);
    } else {
      products[index] = product;
    }
    notifyListeners();
  }

  void deleteProduct(String id) {
    products.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  bool makeSale({
    required Product product,
    required int quantity,
    required String payment,
  }) {
    if (quantity < 1 || quantity > product.stock) return false;
    saveProduct(product.copyWith(stock: product.stock - quantity));
    sales.insert(
      0,
      Sale(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        productId: product.id,
        productName: product.name,
        quantity: quantity,
        total: product.price * quantity,
        costTotal: product.cost * quantity,
        payment: payment,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
    return true;
  }

  void addExpense({
    required String category,
    required String note,
    required int amount,
    required DateTime date,
  }) {
    expenses.insert(
      0,
      Expense(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        category: category,
        note: note,
        amount: amount,
        date: date,
      ),
    );
    notifyListeners();
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: _navy,
              borderRadius: BorderRadius.circular(26),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              size: 52,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'UMKM\nSMART ASSISTANT',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Kelola usaha lebih mudah\ndengan satu aplikasi',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted),
          ),
          const SizedBox(height: 46),
          const SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ],
      ),
    ),
  );
}

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegister;
  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool obscure = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
    child: Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.storefront_rounded, color: _blue, size: 48),
          const SizedBox(height: 26),
          const Text(
            'Selamat Datang!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Kelola UMKM lebih mudah',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted),
          ),
          const SizedBox(height: 38),
          const FieldLabel('Email'),
          TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Masukkan email'),
            validator: requiredValidator,
          ),
          const SizedBox(height: 16),
          const FieldLabel('Password'),
          TextFormField(
            controller: password,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: 'Masukkan password',
              suffixIcon: IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () => setState(() => obscure = !obscure),
              ),
            ),
            validator: requiredValidator,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed:
                  () => showSnack(
                    context,
                    'Silakan hubungi admin untuk mengatur ulang password.',
                  ),
              child: const Text('Lupa Password?'),
            ),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: 'LOGIN',
            onPressed: () {
              if (formKey.currentState!.validate()) widget.onLogin();
            },
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Belum punya akun? '),
              TextButton(
                onPressed: widget.onRegister,
                child: const Text('Register'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegistered;
  final VoidCallback onBack;
  const RegisterScreen({
    super.key,
    required this.onRegistered,
    required this.onBack,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  bool obscure = true;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
    showBack: true,
    onBack: widget.onBack,
    child: Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Buat Akun',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 30),
          const FieldLabel('Nama Lengkap'),
          TextFormField(
            controller: name,
            decoration: const InputDecoration(
              hintText: 'Masukkan nama lengkap',
            ),
            validator: requiredValidator,
          ),
          const SizedBox(height: 14),
          const FieldLabel('Email'),
          TextFormField(
            controller: email,
            decoration: const InputDecoration(hintText: 'Masukkan email'),
            keyboardType: TextInputType.emailAddress,
            validator: requiredValidator,
          ),
          const SizedBox(height: 14),
          const FieldLabel('Password'),
          TextFormField(
            controller: password,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: 'Masukkan password',
              suffixIcon: IconButton(
                onPressed: () => setState(() => obscure = !obscure),
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
            validator: requiredValidator,
          ),
          const SizedBox(height: 14),
          const FieldLabel('Konfirmasi Password'),
          TextFormField(
            controller: confirm,
            obscureText: obscure,
            decoration: const InputDecoration(hintText: 'Konfirmasi password'),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Wajib diisi';
              if (value != password.text) return 'Password belum sama';
              return null;
            },
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: 'DAFTAR SEKARANG',
            onPressed: () {
              if (formKey.currentState!.validate()) widget.onRegistered();
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sudah punya akun? '),
              TextButton(onPressed: widget.onBack, child: const Text('Login')),
            ],
          ),
        ],
      ),
    ),
  );
}

class BusinessSetupScreen extends StatefulWidget {
  final UmkmStore store;
  final VoidCallback onSaved;
  const BusinessSetupScreen({
    super.key,
    required this.store,
    required this.onSaved,
  });

  @override
  State<BusinessSetupScreen> createState() => _BusinessSetupScreenState();
}

class _BusinessSetupScreenState extends State<BusinessSetupScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController business;
  late final TextEditingController owner;
  late final TextEditingController address;
  late final TextEditingController phone;
  String category = 'Makanan';

  @override
  void initState() {
    super.initState();
    final p = widget.store.profile;
    business = TextEditingController(text: p.businessName);
    owner = TextEditingController(text: p.ownerName);
    address = TextEditingController(text: p.address);
    phone = TextEditingController(text: p.phone);
  }

  @override
  void dispose() {
    business.dispose();
    owner.dispose();
    address.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profil UMKM')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF0FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_a_photo_outlined,
                        color: _blue,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tambah logo',
                      style: TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const FieldLabel('Nama Usaha'),
              TextFormField(
                controller: business,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Siti Snack',
                ),
                validator: requiredValidator,
              ),
              const SizedBox(height: 14),
              const FieldLabel('Nama Pemilik'),
              TextFormField(
                controller: owner,
                decoration: const InputDecoration(hintText: 'Nama pemilik'),
                validator: requiredValidator,
              ),
              const SizedBox(height: 14),
              const FieldLabel('Jenis Usaha'),
              DropdownButtonFormField<String>(
                value: category,
                items:
                    const ['Makanan', 'Minuman', 'Fashion', 'Jasa', 'Lainnya']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (value) => setState(() => category = value!),
              ),
              const SizedBox(height: 14),
              const FieldLabel('Alamat'),
              TextFormField(
                controller: address,
                decoration: const InputDecoration(hintText: 'Alamat usaha'),
                validator: requiredValidator,
              ),
              const SizedBox(height: 14),
              const FieldLabel('Nomor Kontak'),
              TextFormField(
                controller: phone,
                decoration: const InputDecoration(hintText: '08xxxxxxxxxx'),
                keyboardType: TextInputType.phone,
                validator: requiredValidator,
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                label: 'SIMPAN & LANJUT',
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    widget.store.updateProfile(
                      BusinessProfile(
                        businessName: business.text.trim(),
                        ownerName: owner.text.trim(),
                        category: category,
                        address: address.text.trim(),
                        phone: phone.text.trim(),
                      ),
                    );
                    widget.onSaved();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class MainShell extends StatefulWidget {
  final UmkmStore store;
  final VoidCallback onLogout;
  const MainShell({super.key, required this.store, required this.onLogout});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(
        store: widget.store,
        openTab: (i) => setState(() => index = i),
      ),
      ProductsScreen(store: widget.store),
      TransactionScreen(store: widget.store),
      AnalysisScreen(store: widget.store),
      ProfileScreen(store: widget.store, onLogout: widget.onLogout),
    ];
    return Scaffold(
      body: SafeArea(child: pages[index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        height: 68,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Produk',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Transaksi',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Analisis',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final UmkmStore store;
  final ValueChanged<int> openTab;
  const DashboardScreen({
    super.key,
    required this.store,
    required this.openTab,
  });

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder:
        (context, _) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hai, ${store.profile.ownerName.split(' ').first} 👋',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            store.profile.businessName,
                            style: const TextStyle(color: _muted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed:
                          () => go(context, NotificationScreen(store: store)),
                      icon: const Icon(Icons.notifications_none_rounded),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    InfoCard(
                      child: Column(
                        children: [
                          const Text(
                            'OMZET HARI INI',
                            style: TextStyle(
                              fontSize: 11,
                              color: _muted,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            rupiah(store.revenue),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '↗ 12% dibanding minggu lalu',
                            style: TextStyle(fontSize: 11, color: _green),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SmallStat(
                            label: 'Pengeluaran',
                            value: rupiah(store.expenseTotal),
                            color: _orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SmallStat(
                            label: 'Keuntungan',
                            value: rupiah(store.profit),
                            color: _green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SectionTitle(
                      title: 'Penjualan (7 Hari Terakhir)',
                      trailing: 'Lihat detail',
                      onTap: () => openTab(2),
                    ),
                    const SizedBox(height: 8),
                    InfoCard(
                      child: SizedBox(
                        height: 132,
                        child: SalesChart(sales: store.sales),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: QuickAction(
                            icon: Icons.add_shopping_cart_outlined,
                            label: 'Penjualan',
                            color: _green,
                            onTap:
                                () => go(context, NewSaleScreen(store: store)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: QuickAction(
                            icon: Icons.add_box_outlined,
                            label: 'Produk',
                            color: _blue,
                            onTap:
                                () => go(
                                  context,
                                  ProductFormScreen(store: store),
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: QuickAction(
                            icon: Icons.remove_circle_outline,
                            label: 'Pengeluaran',
                            color: _orange,
                            onTap:
                                () => go(
                                  context,
                                  ExpenseFormScreen(store: store),
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    SectionTitle(
                      title: 'Produk Terlaris',
                      trailing: 'Lihat semua',
                      onTap: () => openTab(1),
                    ),
                    ...topProducts(store)
                        .take(3)
                        .map((e) => ProductRank(product: e.$1, sold: e.$2)),
                    if (store.lowStock.isNotEmpty) ...[
                      const SizedBox(height: 17),
                      SectionTitle(
                        title: 'Stok perlu diisi',
                        trailing: '${store.lowStock.length} produk',
                      ),
                      ...store.lowStock.map((p) => LowStockTile(product: p)),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
  );
}

class ProductsScreen extends StatefulWidget {
  final UmkmStore store;
  const ProductsScreen({super.key, required this.store});
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String query = '';
  String category = 'Semua';
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.store,
    builder: (context, _) {
      final categories = [
        'Semua',
        ...widget.store.products.map((p) => p.category).toSet(),
      ];
      final filtered =
          widget.store.products
              .where(
                (p) =>
                    (category == 'Semua' || p.category == category) &&
                    p.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
      return Scaffold(
        appBar: AppBar(
          title: const Text('Produk'),
          actions: [
            IconButton(
              onPressed:
                  () => go(context, ProductFormScreen(store: widget.store)),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(18, 6, 18, 12),
          child: Column(
            children: [
              TextField(
                onChanged: (value) => setState(() => query = value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Cari produk...',
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder:
                      (context, i) => ChoiceChip(
                        label: Text(categories[i]),
                        selected: category == categories[i],
                        onSelected:
                            (_) => setState(() => category = categories[i]),
                      ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child:
                    filtered.isEmpty
                        ? const EmptyState(
                          icon: Icons.inventory_2_outlined,
                          title: 'Produk tidak ditemukan',
                        )
                        : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 10),
                          itemBuilder:
                              (context, i) => ProductTile(
                                product: filtered[i],
                                onTap:
                                    () => go(
                                      context,
                                      ProductDetailScreen(
                                        store: widget.store,
                                        productId: filtered[i].id,
                                      ),
                                    ),
                              ),
                        ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => go(context, ProductFormScreen(store: widget.store)),
          icon: const Icon(Icons.add),
          label: const Text('Produk'),
        ),
      );
    },
  );
}

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const ProductTile({super.key, required this.product, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: InfoCard(
      child: Row(
        children: [
          ProductImage(label: product.name),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  rupiah(product.price),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stok: ${product.stock}',
                  style: TextStyle(
                    fontSize: 12,
                    color: product.stock <= product.minStock ? _red : _muted,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade500),
        ],
      ),
    ),
  );
}

class ProductFormScreen extends StatefulWidget {
  final UmkmStore store;
  final Product? product;
  const ProductFormScreen({super.key, required this.store, this.product});
  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController name;
  late final TextEditingController cost;
  late final TextEditingController price;
  late final TextEditingController stock;
  late final TextEditingController minStock;
  String category = 'Makanan Ringan';
  @override
  void initState() {
    super.initState();
    final p = widget.product;
    name = TextEditingController(text: p?.name ?? '');
    cost = TextEditingController(text: p?.cost.toString() ?? '');
    price = TextEditingController(text: p?.price.toString() ?? '');
    stock = TextEditingController(text: p?.stock.toString() ?? '');
    minStock = TextEditingController(text: p?.minStock.toString() ?? '5');
    category = p?.category ?? category;
  }

  @override
  void dispose() {
    name.dispose();
    cost.dispose();
    price.dispose();
    stock.dispose();
    minStock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.product == null ? 'Tambah Produk' : 'Edit Produk'),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F3F7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined, size: 32),
                    SizedBox(height: 4),
                    Text('Tambah Foto', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const FieldLabel('Nama Produk'),
            TextFormField(
              controller: name,
              decoration: const InputDecoration(hintText: 'Nama produk'),
              validator: requiredValidator,
            ),
            const SizedBox(height: 14),
            const FieldLabel('Kategori'),
            DropdownButtonFormField(
              value: category,
              items:
                  const ['Makanan Ringan', 'Makanan', 'Minuman', 'Lainnya']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (value) => setState(() => category = value!),
            ),
            const SizedBox(height: 14),
            const FieldLabel('Harga Modal'),
            TextFormField(
              controller: cost,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(prefixText: 'Rp  '),
              validator: positiveIntValidator,
            ),
            const SizedBox(height: 14),
            const FieldLabel('Harga Jual'),
            TextFormField(
              controller: price,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(prefixText: 'Rp  '),
              validator: positiveIntValidator,
            ),
            const SizedBox(height: 14),
            const FieldLabel('Stok Awal'),
            TextFormField(
              controller: stock,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: '0'),
              validator: nonNegativeIntValidator,
            ),
            const SizedBox(height: 14),
            const FieldLabel('Batas Minimum Stok'),
            TextFormField(
              controller: minStock,
              keyboardType: TextInputType.number,
              validator: nonNegativeIntValidator,
            ),
            const SizedBox(height: 30),
            PrimaryButton(
              label:
                  widget.product == null ? 'SIMPAN PRODUK' : 'SIMPAN PERUBAHAN',
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                widget.store.saveProduct(
                  Product(
                    id:
                        widget.product?.id ??
                        DateTime.now().microsecondsSinceEpoch.toString(),
                    name: name.text.trim(),
                    category: category,
                    cost: int.parse(cost.text),
                    price: int.parse(price.text),
                    stock: int.parse(stock.text),
                    minStock: int.parse(minStock.text),
                  ),
                );
                showSnack(context, 'Produk berhasil disimpan');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

class ProductDetailScreen extends StatelessWidget {
  final UmkmStore store;
  final String productId;
  const ProductDetailScreen({
    super.key,
    required this.store,
    required this.productId,
  });
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) {
      final product = store.productById(productId);
      if (product == null)
        return const Scaffold(
          body: Center(child: Text('Produk sudah dihapus')),
        );
      final relatedSales =
          store.sales.where((s) => s.productId == product.id).toList();
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Produk'),
          actions: [
            IconButton(
              onPressed:
                  () => go(
                    context,
                    ProductFormScreen(store: store, product: product),
                  ),
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: ProductImage(label: product.name, size: 116)),
              const SizedBox(height: 20),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Chip(label: Text(product.category)),
              const SizedBox(height: 12),
              InfoCard(
                child: Column(
                  children: [
                    DetailRow(
                      label: 'Harga Jual',
                      value: rupiah(product.price),
                    ),
                    DetailRow(
                      label: 'Harga Modal',
                      value: rupiah(product.cost),
                    ),
                    DetailRow(
                      label: 'Stok',
                      value: '${product.stock} pcs',
                      valueColor:
                          product.stock <= product.minStock ? _red : null,
                    ),
                    DetailRow(
                      label: 'Minimum Stok',
                      value: '${product.minStock} pcs',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Riwayat Penjualan',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              if (relatedSales.isEmpty)
                const Text(
                  'Belum ada penjualan',
                  style: TextStyle(color: _muted),
                )
              else
                ...relatedSales.map(
                  (s) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      child: Icon(Icons.shopping_bag_outlined),
                    ),
                    title: Text('${s.quantity} produk • ${s.payment}'),
                    subtitle: Text(formatDate(s.date)),
                    trailing: Text(
                      rupiah(s.total),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          () => go(
                            context,
                            ProductFormScreen(store: store, product: product),
                          ),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('EDIT'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(foregroundColor: _red),
                      onPressed:
                          () => confirmDelete(context, product.name, () {
                            store.deleteProduct(product.id);
                            Navigator.pop(context);
                          }),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('HAPUS'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class TransactionScreen extends StatelessWidget {
  final UmkmStore store;
  const TransactionScreen({super.key, required this.store});
  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        bottom: const TabBar(
          tabs: [Tab(text: 'Penjualan'), Tab(text: 'Pengeluaran')],
        ),
      ),
      body: TabBarView(
        children: [SalesList(store: store), ExpenseList(store: store)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            () => showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder:
                  (context) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFFE8F8F1),
                              child: Icon(
                                Icons.add_shopping_cart,
                                color: _green,
                              ),
                            ),
                            title: const Text('Catat Penjualan'),
                            onTap: () {
                              Navigator.pop(context);
                              go(context, NewSaleScreen(store: store));
                            },
                          ),
                          ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFFFFF4DB),
                              child: Icon(
                                Icons.remove_circle_outline,
                                color: _orange,
                              ),
                            ),
                            title: const Text('Catat Pengeluaran'),
                            onTap: () {
                              Navigator.pop(context);
                              go(context, ExpenseFormScreen(store: store));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
        icon: const Icon(Icons.add),
        label: const Text('Transaksi'),
      ),
    ),
  );
}

class SalesList extends StatelessWidget {
  final UmkmStore store;
  const SalesList({super.key, required this.store});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder:
        (_, __) => ListView.separated(
          padding: const EdgeInsets.all(18),
          itemCount: store.sales.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final sale = store.sales[index];
            return InfoCard(
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE8F8F1),
                    child: Icon(Icons.shopping_bag_outlined, color: _green),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sale.productName,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${sale.quantity} produk • ${sale.payment}\n${formatDate(sale.date)}',
                          style: const TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    rupiah(sale.total),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            );
          },
        ),
  );
}

class ExpenseList extends StatelessWidget {
  final UmkmStore store;
  const ExpenseList({super.key, required this.store});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder:
        (_, __) => ListView.separated(
          padding: const EdgeInsets.all(18),
          itemCount: store.expenses.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = store.expenses[index];
            return InfoCard(
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFFFF4DB),
                    child: Icon(Icons.receipt_long_outlined, color: _orange),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.category,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${item.note}\n${formatDate(item.date)}',
                          style: const TextStyle(color: _muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    rupiah(item.amount),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            );
          },
        ),
  );
}

class NewSaleScreen extends StatefulWidget {
  final UmkmStore store;
  const NewSaleScreen({super.key, required this.store});
  @override
  State<NewSaleScreen> createState() => _NewSaleScreenState();
}

class _NewSaleScreenState extends State<NewSaleScreen> {
  String? productId;
  int quantity = 1;
  String payment = 'Cash';
  @override
  Widget build(BuildContext context) {
    final product =
        productId == null ? null : widget.store.productById(productId!);
    return Scaffold(
      appBar: AppBar(title: const Text('Penjualan')),
      body: AnimatedBuilder(
        animation: widget.store,
        builder:
            (context, _) => SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FieldLabel('Pilih Produk'),
                  DropdownButtonFormField<String>(
                    value: productId,
                    hint: const Text('Pilih produk'),
                    items:
                        widget.store.products
                            .map(
                              (p) => DropdownMenuItem(
                                value: p.id,
                                child: Text('${p.name} (stok ${p.stock})'),
                              ),
                            )
                            .toList(),
                    onChanged:
                        (value) => setState(() {
                          productId = value;
                          quantity = 1;
                        }),
                  ),
                  if (product != null) ...[
                    const SizedBox(height: 25),
                    InfoCard(
                      child: Row(
                        children: [
                          ProductImage(label: product.name, size: 60),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Harga satuan ${rupiah(product.price)}',
                                  style: const TextStyle(
                                    color: _muted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const FieldLabel('Jumlah'),
                    Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed:
                              quantity > 1
                                  ? () => setState(() => quantity--)
                                  : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Expanded(
                          child: Text(
                            '$quantity',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton.filledTonal(
                          onPressed:
                              quantity < product.stock
                                  ? () => setState(() => quantity++)
                                  : null,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    Text(
                      'Stok tersedia: ${product.stock}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                    const SizedBox(height: 24),
                    const FieldLabel('Metode Pembayaran'),
                    Row(
                      children:
                          ['Cash', 'Transfer']
                              .map(
                                (item) => Expanded(
                                  child: RadioListTile<String>(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      item,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    value: item,
                                    groupValue: payment,
                                    onChanged:
                                        (value) =>
                                            setState(() => payment = value!),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 16),
                    InfoCard(
                      child: DetailRow(
                        label: 'TOTAL',
                        value: rupiah(product.price * quantity),
                        bold: true,
                      ),
                    ),
                    const SizedBox(height: 26),
                    PrimaryButton(
                      label: 'SIMPAN TRANSAKSI',
                      onPressed: () {
                        final saved = widget.store.makeSale(
                          product: product,
                          quantity: quantity,
                          payment: payment,
                        );
                        if (saved) {
                          showSnack(context, 'Penjualan berhasil disimpan');
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ] else ...[
                    const SizedBox(height: 160),
                    const EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'Pilih produk untuk memulai',
                    ),
                  ],
                ],
              ),
            ),
      ),
    );
  }
}

class ExpenseFormScreen extends StatefulWidget {
  final UmkmStore store;
  const ExpenseFormScreen({super.key, required this.store});
  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final formKey = GlobalKey<FormState>();
  final amount = TextEditingController();
  final note = TextEditingController();
  String category = 'Operasional';
  DateTime date = DateTime.now();
  @override
  void dispose() {
    amount.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tambah Pengeluaran')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FieldLabel('Kategori'),
            DropdownButtonFormField(
              value: category,
              items:
                  const [
                        'Operasional',
                        'Bahan Baku',
                        'Gaji',
                        'Transportasi',
                        'Lainnya',
                      ]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: (value) => setState(() => category = value!),
            ),
            const SizedBox(height: 16),
            const FieldLabel('Nominal'),
            TextFormField(
              controller: amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: 'Rp  ',
                hintText: '0',
              ),
              validator: positiveIntValidator,
            ),
            const SizedBox(height: 16),
            const FieldLabel('Tanggal'),
            InkWell(
              onTap: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (selected != null) setState(() => date = selected);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today_outlined),
                ),
                child: Text(formatDate(date)),
              ),
            ),
            const SizedBox(height: 16),
            const FieldLabel('Keterangan'),
            TextFormField(
              controller: note,
              minLines: 4,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Contoh: beli bahan baku',
              ),
              validator: requiredValidator,
            ),
            const SizedBox(height: 30),
            PrimaryButton(
              label: 'SIMPAN DATA',
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                widget.store.addExpense(
                  category: category,
                  note: note.text.trim(),
                  amount: int.parse(amount.text),
                  date: date,
                );
                showSnack(context, 'Pengeluaran berhasil disimpan');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

class AnalysisScreen extends StatelessWidget {
  final UmkmStore store;
  const AnalysisScreen({super.key, required this.store});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder:
        (context, _) => Scaffold(
          appBar: AppBar(title: const Text('Analisis Usaha')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const FieldLabel('Periode'),
              DropdownButtonFormField(
                value: '7 Hari Terakhir',
                items:
                    const ['7 Hari Terakhir', 'Bulan Ini', 'Tahun Ini']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: SmallStat(
                      label: 'Omzet',
                      value: rupiah(store.revenue),
                      color: _blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SmallStat(
                      label: 'Keuntungan',
                      value: rupiah(store.profit),
                      color: _green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Tren Penjualan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              InfoCard(
                child: SizedBox(
                  height: 170,
                  child: SalesChart(sales: store.sales, showLabels: true),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Produk Terlaris',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              ...topProducts(
                store,
              ).take(4).map((e) => ProductRank(product: e.$1, sold: e.$2)),
              const SizedBox(height: 22),
              const Text(
                'Asisten Marketing AI',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Buat ide konten promosi dari data produk Anda.',
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: 'BUKA AI MARKETING',
                      icon: Icons.auto_awesome,
                      onPressed:
                          () => go(context, MarketingScreen(store: store)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Laporan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              InfoCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    child: Icon(Icons.description_outlined),
                  ),
                  title: const Text('Ringkasan laporan usaha'),
                  subtitle: const Text('Penjualan, pengeluaran, keuntungan'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => go(context, ReportScreen(store: store)),
                ),
              ),
            ],
          ),
        ),
  );
}

class MarketingScreen extends StatefulWidget {
  final UmkmStore store;
  const MarketingScreen({super.key, required this.store});
  @override
  State<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen> {
  String? productId;
  String audience = 'Mahasiswa dan anak muda';
  String type = 'Caption';
  String? result;
  @override
  Widget build(BuildContext context) {
    final p = productId == null ? null : widget.store.productById(productId!);
    return Scaffold(
      appBar: AppBar(title: const Text('AI Marketing Assistant')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Bantu buat konten pemasaran untuk produkmu.',
            style: TextStyle(color: _muted),
          ),
          const SizedBox(height: 20),
          const FieldLabel('Pilih Produk'),
          DropdownButtonFormField<String>(
            value: productId,
            hint: const Text('Pilih produk'),
            items:
                widget.store.products
                    .map(
                      (p) => DropdownMenuItem(value: p.id, child: Text(p.name)),
                    )
                    .toList(),
            onChanged: (value) => setState(() => productId = value),
          ),
          const SizedBox(height: 16),
          const FieldLabel('Target Pelanggan'),
          DropdownButtonFormField(
            value: audience,
            items:
                const [
                      'Mahasiswa dan anak muda',
                      'Keluarga',
                      'Pekerja kantoran',
                      'Umum',
                    ]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (value) => setState(() => audience = value!),
          ),
          const SizedBox(height: 16),
          const FieldLabel('Jenis Konten'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                ['Caption', 'Deskripsi', 'Ide Konten', 'Slogan', 'Promosi']
                    .map(
                      (item) => ChoiceChip(
                        label: Text(item),
                        selected: type == item,
                        onSelected: (_) => setState(() => type = item),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'GENERATE KONTEN',
            icon: Icons.auto_awesome,
            onPressed:
                p == null
                    ? null
                    : () => setState(
                      () => result = makeMarketingCopy(p, type, audience),
                    ),
          ),
          if (result != null) ...[
            const SizedBox(height: 24),
            const Text(
              'Hasil AI',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            InfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: _blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(result!, style: const TextStyle(height: 1.45)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed:
                              () => showSnack(context, 'Konten siap disalin'),
                          icon: const Icon(Icons.copy_outlined),
                          label: const Text('SALIN'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed:
                              () => setState(
                                () =>
                                    result = makeMarketingCopy(
                                      p!,
                                      type,
                                      audience,
                                    ),
                              ),
                          icon: const Icon(Icons.refresh),
                          label: const Text('BUAT LAGI'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ReportScreen extends StatelessWidget {
  final UmkmStore store;
  const ReportScreen({super.key, required this.store});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder:
          (context, _) => Scaffold(
            appBar: AppBar(title: const Text('Laporan')),
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const FieldLabel('Periode'),
                DropdownButtonFormField<String>(
                  value: 'Bulan Ini',
                  items:
                      const ['Bulan Ini', '3 Bulan Terakhir', 'Tahun Ini']
                          .map(
                            (period) => DropdownMenuItem(
                              value: period,
                              child: Text(period),
                            ),
                          )
                          .toList(),
                  onChanged: (_) {},
                ),
                const SizedBox(height: 20),
                ReportTile(
                  icon: Icons.trending_up,
                  color: _green,
                  title: 'Penjualan',
                  subtitle: 'Total: ${rupiah(store.revenue)}',
                  onTap: () => go(context, TransactionScreen(store: store)),
                ),
                ReportTile(
                  icon: Icons.receipt_long,
                  color: _orange,
                  title: 'Pengeluaran',
                  subtitle: 'Total: ${rupiah(store.expenseTotal)}',
                  onTap: () => go(context, TransactionScreen(store: store)),
                ),
                ReportTile(
                  icon: Icons.account_balance_wallet_outlined,
                  color: _blue,
                  title: 'Keuntungan',
                  subtitle: 'Total: ${rupiah(store.profit)}',
                  onTap:
                      () => showSnack(
                        context,
                        'Keuntungan = omzet − modal produk terjual − pengeluaran',
                      ),
                ),
                ReportTile(
                  icon: Icons.inventory_2_outlined,
                  color: Colors.purple,
                  title: 'Stok',
                  subtitle:
                      '${store.lowStock.length} produk perlu diperhatikan',
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: 'LIHAT RINGKASAN',
                  icon: Icons.visibility_outlined,
                  onPressed:
                      () => showDialog<void>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Ringkasan Usaha'),
                              content: Text(
                                'Omzet ${rupiah(store.revenue)}\n'
                                'Pengeluaran ${rupiah(store.expenseTotal)}\n'
                                'Keuntungan ${rupiah(store.profit)}',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Tutup'),
                                ),
                              ],
                            ),
                      ),
                ),
              ],
            ),
          ),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  final UmkmStore store;
  const NotificationScreen({super.key, required this.store});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder:
        (_, __) => Scaffold(
          appBar: AppBar(title: const Text('Notifikasi')),
          body: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              if (store.lowStock.isNotEmpty)
                ...store.lowStock.map(
                  (p) => NotificationTile(
                    icon: Icons.inventory_2_outlined,
                    color: _orange,
                    title: 'Stok rendah',
                    body: '${p.name} tersisa ${p.stock} produk',
                    time: '10 menit lalu',
                  ),
                )
              else
                const NotificationTile(
                  icon: Icons.check_circle_outline,
                  color: _green,
                  title: 'Stok aman',
                  body: 'Tidak ada produk yang perlu diisi ulang.',
                  time: 'Hari ini',
                ),
              const NotificationTile(
                icon: Icons.shopping_bag_outlined,
                color: _green,
                title: 'Transaksi tersimpan',
                body: 'Penjualan terakhir berhasil dicatat.',
                time: '1 jam lalu',
              ),
              const NotificationTile(
                icon: Icons.lightbulb_outline,
                color: _blue,
                title: 'Ide promosi',
                body: 'Gunakan AI Marketing untuk membuat konten hari ini.',
                time: 'Kemarin',
              ),
            ],
          ),
        ),
  );
}

class ProfileScreen extends StatelessWidget {
  final UmkmStore store;
  final VoidCallback onLogout;
  const ProfileScreen({super.key, required this.store, required this.onLogout});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder:
        (_, __) => Scaffold(
          appBar: AppBar(title: const Text('Profil')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: const Color(0xFFE5EBF4),
                    child: Text(
                      store.profile.businessName.characters.first.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: _blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    store.profile.businessName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    store.profile.ownerName,
                    style: const TextStyle(color: _muted),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              InfoCard(
                child: Column(
                  children: [
                    ProfileRow(
                      icon: Icons.storefront_outlined,
                      label: 'Informasi UMKM',
                      onTap:
                          () => go(
                            context,
                            BusinessSetupScreen(
                              store: store,
                              onSaved: () => Navigator.pop(context),
                            ),
                          ),
                    ),
                    ProfileRow(
                      icon: Icons.person_outline,
                      label: 'Edit Profil',
                      onTap:
                          () => showSnack(
                            context,
                            'Profil pemilik dapat diperbarui pada Informasi UMKM',
                          ),
                    ),
                    ProfileRow(
                      icon: Icons.receipt_long_outlined,
                      label: 'Pengaturan Akun',
                      onTap:
                          () => showSnack(
                            context,
                            'Pengaturan akun tersedia segera',
                          ),
                    ),
                    ProfileRow(
                      icon: Icons.notifications_none,
                      label: 'Notifikasi',
                      onTap:
                          () => go(context, NotificationScreen(store: store)),
                    ),
                    ProfileRow(
                      icon: Icons.help_outline,
                      label: 'Bantuan',
                      onTap:
                          () => showSnack(
                            context,
                            'Hubungi admin untuk bantuan penggunaan aplikasi',
                          ),
                    ),
                    ProfileRow(
                      icon: Icons.info_outline,
                      label: 'Tentang Aplikasi',
                      onTap:
                          () => showAboutDialog(
                            context: context,
                            applicationName: 'UMKM Smart Assistant',
                            applicationVersion: '1.0.0',
                            children: [
                              const Text(
                                'Asisten sederhana untuk pencatatan dan analisis usaha UMKM.',
                              ),
                            ],
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: _red,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed:
                    () => showDialog(
                      context: context,
                      builder:
                          (dialogContext) => AlertDialog(
                            title: const Text('Keluar dari akun?'),
                            content: const Text(
                              'Anda perlu login kembali untuk mengakses aplikasi.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Batal'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                  onLogout();
                                },
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                    ),
                icon: const Icon(Icons.logout),
                label: const Text('LOGOUT'),
              ),
            ],
          ),
        ),
  );
}

class AuthScaffold extends StatelessWidget {
  final Widget child;
  final bool showBack;
  final VoidCallback? onBack;
  const AuthScaffold({
    super.key,
    required this.child,
    this.showBack = false,
    this.onBack,
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showBack)
              IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
            child,
          ],
        ),
      ),
    ),
  );
}

class FieldLabel extends StatelessWidget {
  final String label;
  const FieldLabel(this.label, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Text(
      label,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
    ),
  );
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });
  @override
  Widget build(BuildContext context) => FilledButton.icon(
    onPressed: onPressed,
    icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
    label: Text(label),
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(50),
      backgroundColor: _navy,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        letterSpacing: .2,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

class InfoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const InfoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });
  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: Color(0xFFE5EAF0)),
    ),
    child: Padding(padding: padding, child: child),
  );
}

class SmallStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const SmallStat({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => InfoCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.circle, color: color, size: 11),
        const SizedBox(height: 7),
        Text(label, style: const TextStyle(color: _muted, fontSize: 11)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String trailing;
  final VoidCallback? onTap;
  const SectionTitle({
    super.key,
    required this.title,
    required this.trailing,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
      TextButton(
        onPressed: onTap,
        child: Text(trailing, style: const TextStyle(fontSize: 12)),
      ),
    ],
  );
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const QuickAction({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5EAF0)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class ProductImage extends StatelessWidget {
  final String label;
  final double size;
  const ProductImage({super.key, required this.label, this.size = 62});
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: const Color(0xFFF0F3F7),
      borderRadius: BorderRadius.circular(size * .18),
    ),
    child: Icon(
      label.toLowerCase().contains('donat')
          ? Icons.donut_large_outlined
          : Icons.image_outlined,
      color: _muted,
      size: size * .38,
    ),
  );
}

class ProductRank extends StatelessWidget {
  final Product product;
  final int sold;
  const ProductRank({super.key, required this.product, required this.sold});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        ProductImage(label: product.name, size: 42),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Text('${sold}x', style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    ),
  );
}

class LowStockTile extends StatelessWidget {
  final Product product;
  const LowStockTile({super.key, required this.product});
  @override
  Widget build(BuildContext context) => InfoCard(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 17,
          backgroundColor: Color(0xFFFFF2F4),
          child: Icon(Icons.warning_amber_rounded, color: _red, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          'Stok ${product.stock}',
          style: const TextStyle(
            fontSize: 12,
            color: _red,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;
  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: bold ? _ink : _muted,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w400,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w800, color: valueColor),
        ),
      ],
    ),
  );
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  const EmptyState({super.key, required this.icon, required this.title});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 45, color: _muted),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(color: _muted)),
      ],
    ),
  );
}

class SalesChart extends StatelessWidget {
  final List<Sale> sales;
  final bool showLabels;
  const SalesChart({super.key, required this.sales, this.showLabels = false});
  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: ChartPainter(sales),
    child:
        showLabels
            ? const Padding(
              padding: EdgeInsets.only(top: 145),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sen', style: TextStyle(fontSize: 10, color: _muted)),
                  Text('Sel', style: TextStyle(fontSize: 10, color: _muted)),
                  Text('Rab', style: TextStyle(fontSize: 10, color: _muted)),
                  Text('Kam', style: TextStyle(fontSize: 10, color: _muted)),
                  Text('Jum', style: TextStyle(fontSize: 10, color: _muted)),
                  Text('Sab', style: TextStyle(fontSize: 10, color: _muted)),
                  Text('Min', style: TextStyle(fontSize: 10, color: _muted)),
                ],
              ),
            )
            : const SizedBox.expand(),
  );
}

class ChartPainter extends CustomPainter {
  final List<Sale> sales;
  ChartPainter(this.sales);
  @override
  void paint(Canvas canvas, Size size) {
    final grid =
        Paint()
          ..color = const Color(0xFFE8EDF3)
          ..strokeWidth = 1;
    for (var i = 1; i < 4; i++) {
      final y = (size.height - 20) * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final now = DateTime.now();
    final values = List<int>.generate(7, (i) {
      final day = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: 6 - i));
      return sales
          .where(
            (s) =>
                s.date.year == day.year &&
                s.date.month == day.month &&
                s.date.day == day.day,
          )
          .fold(0, (sum, item) => sum + item.total);
    });
    final max = values.fold(1, (a, b) => a > b ? a : b).toDouble();
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / 6;
      final y = 8 + (size.height - 32) * (1 - values[i] / max);
      if (i == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / 6;
      final y = 8 + (size.height - 32) * (1 - values[i] / max);
      canvas.drawCircle(Offset(x, y), 3.5, Paint()..color = Colors.white);
      canvas.drawCircle(Offset(x, y), 2.2, Paint()..color = _blue);
    }
  }

  @override
  bool shouldRepaint(covariant ChartPainter oldDelegate) =>
      oldDelegate.sales != sales;
}

class ReportTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const ReportTile({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: InfoCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.12),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    ),
  );
}

class NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;
  const NotificationTile({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: InfoCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(body, style: const TextStyle(color: _muted, fontSize: 13)),
                const SizedBox(height: 5),
                Text(time, style: const TextStyle(color: _muted, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const ProfileRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: _ink),
    title: Text(label),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
  );
}

String? requiredValidator(String? value) =>
    value == null || value.trim().isEmpty ? 'Wajib diisi' : null;
String? positiveIntValidator(String? value) {
  final parsed = int.tryParse(value ?? '');
  return parsed == null || parsed < 1 ? 'Masukkan nominal yang valid' : null;
}

String? nonNegativeIntValidator(String? value) {
  final parsed = int.tryParse(value ?? '');
  return parsed == null || parsed < 0 ? 'Masukkan angka yang valid' : null;
}

String rupiah(int value) {
  final text = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final left = text.length - i;
    buffer.write(text[i]);
    if (left > 1 && left % 3 == 1) buffer.write('.');
  }
  return '${value < 0 ? '-' : ''}Rp${buffer.toString()}';
}

String formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];
  return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
}

void go(BuildContext context, Widget page) =>
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
void showSnack(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
void confirmDelete(BuildContext context, String name, VoidCallback onConfirm) =>
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Hapus produk?'),
            content: Text('$name akan dihapus dari daftar produk.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  onConfirm();
                },
                child: const Text('Hapus'),
              ),
            ],
          ),
    );
List<(Product, int)> topProducts(UmkmStore store) {
  final map = <String, int>{};
  for (final sale in store.sales) {
    map[sale.productId] = (map[sale.productId] ?? 0) + sale.quantity;
  }
  final items = store.products.map((p) => (p, map[p.id] ?? 0)).toList();
  items.sort((a, b) => b.$2.compareTo(a.$2));
  return items;
}

String makeMarketingCopy(Product product, String type, String audience) {
  switch (type) {
    case 'Deskripsi':
      return '${product.name} adalah pilihan nikmat untuk $audience. Dibuat dengan bahan pilihan, cocok dinikmati kapan saja. Pesan sekarang seharga ${rupiah(product.price)}!';
    case 'Ide Konten':
      return 'Buat video singkat: tampilkan proses menyiapkan ${product.name}, close-up teksturnya, lalu ajak audiens memilih teman makan favorit mereka.';
    case 'Slogan':
      return '${product.name}: Sekali Coba, Bikin Ketagihan!';
    case 'Promosi':
      return 'Promo spesial ${product.name} untuk $audience! Nikmati kualitas terbaik hanya ${rupiah(product.price)}. Stok terbatas, pesan sekarang.';
    default:
      return 'Lagi cari camilan yang bikin hari lebih manis? ✨ ${product.name} dari ${product.category} hadir dengan rasa yang istimewa. Cocok untuk $audience. Yuk, pesan sekarang seharga ${rupiah(product.price)}! #UMKMLokal #JajanEnak';
  }
}

extension FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
