part of '../main.dart';

class ProductsScreen extends StatefulWidget {
  final UmkmStore store;
  const ProductsScreen({super.key, required this.store});
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String query = '', category = 'Semua', sort = 'Nama A–Z';
  bool lowOnly = false;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.store,
    builder: (context, _) {
      final store = widget.store;
      final categories = [
        'Semua',
        ...store.products.map((e) => e.category).toSet(),
      ];
      final activeCategory = categories.contains(category) ? category : 'Semua';
      final filtered =
          store.products
              .where(
                (p) =>
                    (activeCategory == 'Semua' ||
                        activeCategory == p.category) &&
                    (!lowOnly || p.stock <= p.minStock) &&
                    '${p.name} ${p.category}'.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
      filtered.sort(
        (a, b) => switch (sort) {
          'Stok terendah' => a.stock.compareTo(b.stock),
          'Harga tertinggi' => b.price.compareTo(a.price),
          _ => a.name.compareTo(b.name),
        },
      );
      return PageBody(
        children: [
          PageHeading(
            eyebrow: 'Katalog & persediaan',
            title: 'Produk yang punya cerita.',
            subtitle: 'Kelola katalog, harga, dan stok dalam satu tempat.',
            action: FilledButton.icon(
              onPressed: () => go(context, ProductFormScreen(store: store)),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Tambah produk'),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Pill(
                '${store.products.length} produk',
                icon: Icons.inventory_2_outlined,
              ),
              Pill(
                '${store.products.fold<int>(0, (s, p) => s + p.stock)} unit tersedia',
                color: _muted,
                background: const Color(0xFFECEFE8),
              ),
              ActionChip(
                avatar: Icon(
                  Icons.warning_amber_rounded,
                  size: 15,
                  color: lowOnly ? Colors.white : _orange,
                ),
                backgroundColor: lowOnly ? _forest : const Color(0xFFF4ECD9),
                side: BorderSide.none,
                label: Text(
                  '${store.lowStock.length} stok menipis',
                  style: TextStyle(
                    fontSize: 11,
                    color: lowOnly ? Colors.white : _orange,
                  ),
                ),
                onPressed: () => setState(() => lowOnly = !lowOnly),
              ),
            ],
          ),
          const SizedBox(height: 22),
          TextField(
            onChanged: (v) => setState(() => query = v),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded, size: 21),
              hintText: 'Cari nama atau kategori produk...',
            ),
          ),
          const SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final item in categories)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      showCheckmark: false,
                      label: Text(
                        item,
                        style: TextStyle(
                          fontSize: 12,
                          color: activeCategory == item ? Colors.white : _muted,
                        ),
                      ),
                      selected: activeCategory == item,
                      onSelected: (_) => setState(() => category = item),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${filtered.length} produk ditampilkan',
                  style: const TextStyle(fontSize: 12, color: _muted),
                ),
              ),
              PopupMenuButton<String>(
                initialValue: sort,
                tooltip: 'Urutkan produk',
                onSelected: (v) => setState(() => sort = v),
                itemBuilder:
                    (_) =>
                        ['Nama A–Z', 'Stok terendah', 'Harga tertinggi']
                            .map((e) => PopupMenuItem(value: e, child: Text(e)))
                            .toList(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    children: [
                      const Icon(Icons.sort_rounded, size: 18, color: _muted),
                      const SizedBox(width: 6),
                      Text(
                        sort,
                        style: const TextStyle(fontSize: 11, color: _muted),
                      ),
                      const Icon(Icons.expand_more, size: 16, color: _muted),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (filtered.isEmpty)
            EmptyView(
              icon: Icons.inventory_2_outlined,
              title:
                  store.products.isEmpty
                      ? 'Produk pertamamu menanti.'
                      : 'Belum ada yang cocok',
              message:
                  store.products.isEmpty
                      ? 'Tambahkan produk untuk mulai melayani pelanggan.'
                      : 'Coba kata kunci, kategori, atau filter stok lain.',
              action:
                  store.products.isEmpty
                      ? FilledButton.icon(
                        onPressed:
                            () => go(context, ProductFormScreen(store: store)),
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah produk'),
                      )
                      : null,
            )
          else
            LayoutBuilder(
              builder: (context, c) {
                final columns =
                    c.maxWidth >= 950
                        ? 4
                        : c.maxWidth >= 650
                        ? 3
                        : 2;
                final width = (c.maxWidth - (columns - 1) * 14) / columns;
                return Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    for (final p in filtered)
                      SizedBox(
                        width: width,
                        child: ProductCard(
                          product: p,
                          onTap:
                              () => go(
                                context,
                                ProductDetailScreen(
                                  store: store,
                                  productId: p.id,
                                ),
                              ),
                        ),
                      ),
                  ],
                );
              },
            ),
        ],
      );
    },
  );
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const ProductCard({super.key, required this.product, required this.onTap});
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(19),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: _line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: ProductArt(product: product, size: 78),
            ),
            const SizedBox(height: 14),
            Text(
              product.category.toUpperCase(),
              style: const TextStyle(
                color: _muted,
                letterSpacing: .5,
                fontSize: 8,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 39,
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              rupiah(product.price),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: _green,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: product.stock <= product.minStock ? _orange : _green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    product.stock == 0 ? 'Stok habis' : '${product.stock} unit',
                    style: TextStyle(
                      color:
                          product.stock <= product.minStock ? _orange : _muted,
                      fontSize: 10,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 15,
                  color: _muted,
                ),
              ],
            ),
          ],
        ),
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
  final form = GlobalKey<FormState>();
  late final name = TextEditingController(text: widget.product?.name);
  late final cost = TextEditingController(
    text: widget.product?.cost.toString(),
  );
  late final price = TextEditingController(
    text: widget.product?.price.toString(),
  );
  late final stock = TextEditingController(
    text: widget.product?.stock.toString() ?? '0',
  );
  late final minimum = TextEditingController(
    text: widget.product?.minStock.toString() ?? '5',
  );
  late String category = widget.product?.category ?? 'Makanan Ringan';
  @override
  void dispose() {
    for (final c in [name, cost, price, stock, minimum]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.product == null ? 'Tambah produk' : 'Edit produk'),
    ),
    body: PageBody(
      maxWidth: 620,
      children: [
        Panel(
          color: const Color(0xFFEAF0E0),
          child: Row(
            children: [
              const Icon(Icons.inventory_2_outlined, color: _green, size: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Detail kecil, kelola lebih baik.',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Harga modal dipakai untuk menghitung laba. Batas stok membantu mengingatkanmu.',
                      style: TextStyle(fontSize: 12, color: _muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Field(
                'Nama produk',
                controller: name,
                hint: 'Contoh: Kopi Susu Aren',
              ),
              const Text(
                'Kategori',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: category,
                items:
                    {
                          ...[
                            'Makanan Ringan',
                            'Makanan',
                            'Minuman',
                            'Fashion',
                            'Jasa',
                            'Lainnya',
                          ],
                          category,
                        }
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (v) => setState(() => category = v!),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Field(
                      'Harga modal (Rp)',
                      controller: cost,
                      number: true,
                      hint: '0',
                      validator: nonNegativeValidator,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Field(
                      'Harga jual (Rp)',
                      controller: price,
                      number: true,
                      hint: '0',
                      validator: positiveValidator,
                    ),
                  ),
                ],
              ),
              ListenableBuilder(
                listenable: Listenable.merge([cost, price]),
                builder: (context, _) {
                  final c = int.tryParse(cost.text) ?? 0;
                  final p = int.tryParse(price.text) ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: Pill(
                      'Margin per unit: ${rupiah(p - c)}',
                      color: p < c ? _red : _green,
                      background:
                          p < c
                              ? const Color(0xFFFBEBE8)
                              : const Color(0xFFEDF4EA),
                      icon: Icons.insights_rounded,
                    ),
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Field(
                      'Stok tersedia',
                      controller: stock,
                      number: true,
                      validator: nonNegativeValidator,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Field(
                      'Batas stok minimum',
                      controller: minimum,
                      number: true,
                      validator: nonNegativeValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: () {
                  if (!form.currentState!.validate()) return;
                  widget.store.saveProduct(
                    Product(
                      id: widget.product?.id ?? widget.store.newId('PRD'),
                      name: name.text.trim(),
                      category: category,
                      cost: int.parse(cost.text),
                      price: int.parse(price.text),
                      stock: int.parse(stock.text),
                      minStock: int.parse(minimum.text),
                    ),
                  );
                  Navigator.pop(context);
                  showSnack(context, 'Produk berhasil disimpan');
                },
                icon: const Icon(Icons.check_rounded),
                label: const Text('Simpan produk'),
              ),
            ],
          ),
        ),
      ],
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
      final p = store.productById(productId);
      if (p == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Detail produk')),
          body: const EmptyView(
            icon: Icons.inventory_2_outlined,
            title: 'Produk sudah dihapus',
            message: 'Riwayat penjualannya tetap tersimpan.',
          ),
        );
      }
      final units = store.sales
          .expand((s) => s.items)
          .where((i) => i.productId == p.id)
          .fold<int>(0, (s, i) => s + i.quantity);
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detail produk'),
          actions: [
            IconButton(
              tooltip: 'Edit produk',
              onPressed:
                  () =>
                      go(context, ProductFormScreen(store: store, product: p)),
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
        body: PageBody(
          maxWidth: 680,
          children: [
            Center(child: ProductArt(product: p, size: 130)),
            const SizedBox(height: 24),
            Center(
              child: Text(
                p.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(child: Pill(p.category)),
            const SizedBox(height: 28),
            Panel(
              child: Column(
                children: [
                  MoneyRow('Harga jual', p.price, bold: true),
                  MoneyRow('Harga modal', p.cost),
                  MoneyRow(
                    'Margin per unit',
                    p.price - p.cost,
                    color: p.price >= p.cost ? _green : _red,
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Stok tersedia',
                          style: TextStyle(color: _muted),
                        ),
                      ),
                      Pill(
                        '${p.stock} unit',
                        color: p.stock <= p.minStock ? _orange : _green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Minimum stok',
                          style: TextStyle(color: _muted),
                        ),
                      ),
                      Text('${p.minStock} unit'),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Total terjual',
                          style: TextStyle(color: _muted),
                        ),
                      ),
                      Text(
                        '$units unit',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: () => restockProduct(context, store, p),
              icon: const Icon(Icons.add_box_outlined),
              label: const Text('Tambah stok'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed:
                  () =>
                      go(context, ProductFormScreen(store: store, product: p)),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit informasi produk'),
            ),
            const SizedBox(height: 22),
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: _red),
              onPressed: () async {
                if (await confirm(
                  context,
                  title: 'Hapus produk?',
                  message:
                      '${p.name} akan dihapus dari katalog. Riwayat penjualan tetap tersimpan.',
                  button: 'Hapus produk',
                  destructive: true,
                )) {
                  store.deleteProduct(p.id);
                  if (context.mounted) {
                    Navigator.pop(context);
                    showSnack(context, 'Produk dihapus dari katalog');
                  }
                }
              },
              icon: const Icon(Icons.delete_outline, size: 19),
              label: const Text('Hapus dari katalog'),
            ),
          ],
        ),
      );
    },
  );
}
