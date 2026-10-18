part of '../main.dart';

class TransactionScreen extends StatefulWidget {
  final UmkmStore store;
  const TransactionScreen({super.key, required this.store});
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  BusinessPeriod period = BusinessPeriod.week;
  bool expenses = false;
  String query = '';
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.store,
    builder: (context, _) {
      final store = widget.store;
      final summary = store.summary(period);
      final sales =
          summary.sales
              .where(
                (e) => '${e.id} ${e.productName} ${e.payment}'
                    .toLowerCase()
                    .contains(query.toLowerCase()),
              )
              .toList()
            ..sort((a, b) => b.date.compareTo(a.date));
      final spending =
          summary.expenses
              .where(
                (e) => '${e.note} ${e.category}'.toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
      return PageBody(
        children: [
          PageHeading(
            eyebrow: 'Catatan usaha',
            title: 'Setiap transaksi berarti.',
            subtitle: 'Riwayat yang rapi, keputusan yang lebih pasti.',
            action: FilledButton.icon(
              onPressed:
                  () => go(
                    context,
                    expenses
                        ? ExpenseFormScreen(store: store)
                        : NewSaleScreen(store: store),
                  ),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(expenses ? 'Catat pengeluaran' : 'Catat penjualan'),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: PeriodPicker(
              value: period,
              onChanged: (v) => setState(() => period = v),
            ),
          ),
          const SizedBox(height: 20),
          Panel(
            child: Column(
              children: [
                MoneyRow('Penjualan masuk', summary.revenue, color: _green),
                MoneyRow('Biaya operasional', summary.spending, color: _orange),
                const Divider(),
                MoneyRow(
                  'Laba setelah modal & biaya',
                  summary.profit,
                  bold: true,
                  color: summary.profit >= 0 ? _green : _red,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _TypeTab(
                  'Penjualan',
                  '${summary.sales.length}',
                  selected: !expenses,
                  onTap: () => setState(() => expenses = false),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TypeTab(
                  'Pengeluaran',
                  '${summary.expenses.length}',
                  selected: expenses,
                  onTap: () => setState(() => expenses = true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            onChanged: (v) => setState(() => query = v),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded),
              hintText:
                  expenses
                      ? 'Cari catatan atau kategori biaya...'
                      : 'Cari produk, nomor transaksi, pembayaran...',
            ),
          ),
          const SizedBox(height: 20),
          if ((!expenses && sales.isEmpty) || (expenses && spending.isEmpty))
            const EmptyView(
              icon: Icons.receipt_long_outlined,
              title: 'Belum ada catatan yang cocok',
              message:
                  'Ubah periode atau kata kunci, atau catat transaksi baru.',
            )
          else
            Panel(
              child: Column(
                children:
                    expenses
                        ? spending.map((e) => ExpenseTile(expense: e)).toList()
                        : sales
                            .map(
                              (s) => SaleTile(
                                sale: s,
                                onTap:
                                    () => go(
                                      context,
                                      ReceiptScreen(store: store, sale: s),
                                    ),
                              ),
                            )
                            .toList(),
              ),
            ),
        ],
      );
    },
  );
}

class _TypeTab extends StatelessWidget {
  final String label, count;
  final bool selected;
  final VoidCallback onTap;
  const _TypeTab(
    this.label,
    this.count, {
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onTap,
    style: OutlinedButton.styleFrom(
      backgroundColor: selected ? _forest : Colors.white,
      foregroundColor: selected ? Colors.white : _muted,
      side: BorderSide(color: selected ? _forest : _line),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          count,
          style: TextStyle(fontSize: 11, color: selected ? _lime : _muted),
        ),
      ],
    ),
  );
}

class SaleTile extends StatelessWidget {
  final Sale sale;
  final VoidCallback onTap;
  const SaleTile({super.key, required this.sale, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF4E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.south_west_rounded,
              color: _green,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sale.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${formatDate(sale.date)} · ${formatTime(sale.date)}',
                  style: const TextStyle(fontSize: 10, color: _muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  rupiah(sale.total),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${sale.quantity} unit · ${sale.payment}',
                  style: const TextStyle(color: _muted, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  const ExpenseTile({super.key, required this.expense});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F0DF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.north_east_rounded, color: _orange, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expense.note,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${expense.category} · ${formatDate(expense.date)}',
                style: const TextStyle(color: _muted, fontSize: 10),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '-${rupiah(expense.amount)}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _orange,
          ),
        ),
      ],
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
  final cart = <String, int>{};
  String query = '';
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.store,
    builder: (context, _) {
      final store = widget.store;
      final products =
          store.products
              .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
      final count = cart.values.fold<int>(0, (s, n) => s + n);
      final total = cart.entries.fold<int>(
        0,
        (s, e) => s + (store.productById(e.key)?.price ?? 0) * e.value,
      );
      return Scaffold(
        appBar: AppBar(title: const Text('Catat penjualan')),
        body: PageBody(
          maxWidth: 760,
          children: [
            const PageHeading(
              eyebrow: 'Kasir praktis',
              title: 'Pesanan baru, peluang baru.',
              subtitle:
                  'Pilih produk dan atur jumlahnya. Stok diperbarui saat disimpan.',
            ),
            TextField(
              onChanged: (v) => setState(() => query = v),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                hintText: 'Cari produk untuk pesanan...',
              ),
            ),
            const SizedBox(height: 20),
            if (products.isEmpty)
              EmptyView(
                icon: Icons.shopping_bag_outlined,
                title:
                    store.products.isEmpty
                        ? 'Katalogmu masih kosong'
                        : 'Produk tidak ditemukan',
                message: 'Tambahkan produk atau coba kata kunci lain.',
                action:
                    store.products.isEmpty
                        ? FilledButton(
                          onPressed:
                              () =>
                                  go(context, ProductFormScreen(store: store)),
                          child: const Text('Tambah produk'),
                        )
                        : null,
              ),
            for (final p in products)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Panel(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      ProductArt(product: p, size: 46),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rupiah(p.price),
                              style: const TextStyle(
                                fontSize: 12,
                                color: _green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              p.stock == 0 ? 'Stok habis' : 'Stok ${p.stock}',
                              style: TextStyle(
                                fontSize: 10,
                                color: p.stock == 0 ? _red : _muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if ((cart[p.id] ?? 0) > 0) ...[
                        IconButton(
                          key: ValueKey('remove-${p.id}'),
                          tooltip: 'Kurangi ${p.name}',
                          onPressed:
                              () => setState(() {
                                if (cart[p.id] == 1) {
                                  cart.remove(p.id);
                                } else {
                                  cart[p.id] = cart[p.id]! - 1;
                                }
                              }),
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            size: 22,
                          ),
                        ),
                        Text(
                          '${cart[p.id]}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                      IconButton(
                        key: ValueKey('add-${p.id}'),
                        tooltip: 'Tambah ${p.name}',
                        onPressed:
                            (cart[p.id] ?? 0) >= p.stock
                                ? null
                                : () => setState(
                                  () => cart[p.id] = (cart[p.id] ?? 0) + 1,
                                ),
                        icon: const Icon(Icons.add_circle_rounded, size: 28),
                        color: _green,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: _line)),
            ),
            child: Center(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          '$count unit dipilih',
                          style: const TextStyle(fontSize: 12, color: _muted),
                        ),
                        const Spacer(),
                        Text(
                          rupiah(total),
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed:
                          cart.isEmpty
                              ? null
                              : () async {
                                final sale = await Navigator.push<Sale>(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => CheckoutScreen(
                                          store: store,
                                          cart: Map.of(cart),
                                        ),
                                  ),
                                );
                                if (sale != null && context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder:
                                          (_) => ReceiptScreen(
                                            store: store,
                                            sale: sale,
                                            justCreated: true,
                                          ),
                                    ),
                                  );
                                }
                              },
                      icon: const Icon(Icons.arrow_forward_rounded, size: 19),
                      label: const Text('Tinjau pesanan'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class CheckoutScreen extends StatefulWidget {
  final UmkmStore store;
  final Map<String, int> cart;
  const CheckoutScreen({super.key, required this.store, required this.cart});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String payment = 'Tunai';
  bool submitting = false;
  @override
  Widget build(BuildContext context) {
    final total = widget.cart.entries.fold<int>(
      0,
      (s, e) => s + (widget.store.productById(e.key)?.price ?? 0) * e.value,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Tinjau pesanan')),
      body: PageBody(
        maxWidth: 620,
        children: [
          const PageHeading(
            eyebrow: 'Satu langkah lagi',
            title: 'Sudah sesuai pesanan?',
            subtitle: 'Periksa produk sebelum mencatat pembayaran.',
          ),
          Panel(
            child: Column(
              children: [
                for (final entry in widget.cart.entries)
                  if (widget.store.productById(entry.key) case final p?)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          ProductArt(product: p, size: 42),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  '${entry.value} × ${rupiah(p.price)}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: _muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            rupiah(p.price * entry.value),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                const Divider(),
                MoneyRow('Total pembayaran', total, bold: true),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Metode pembayaran yang diterima',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pilih setelah pembayaran diterima dari pelanggan.',
            style: TextStyle(fontSize: 12, color: _muted),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final method in ['Tunai', 'QRIS', 'Transfer'])
                ChoiceChip(
                  showCheckmark: false,
                  avatar: Icon(
                    method == 'Tunai'
                        ? Icons.payments_outlined
                        : method == 'QRIS'
                        ? Icons.qr_code_rounded
                        : Icons.account_balance_outlined,
                    size: 18,
                    color: payment == method ? _lime : _muted,
                  ),
                  label: Text(
                    method,
                    style: TextStyle(
                      color: payment == method ? Colors.white : _muted,
                    ),
                  ),
                  selected: payment == method,
                  onSelected: (_) => setState(() => payment = method),
                ),
            ],
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            key: const ValueKey('confirm-sale'),
            onPressed:
                submitting
                    ? null
                    : () {
                      setState(() => submitting = true);
                      final sale = widget.store.checkout(widget.cart, payment);
                      if (sale == null) {
                        setState(() => submitting = false);
                        showSnack(
                          context,
                          'Stok berubah atau tidak mencukupi. Periksa kembali pesanan.',
                        );
                        return;
                      }
                      Navigator.pop(context, sale);
                    },
            icon: const Icon(Icons.check_rounded),
            label: const Text('Pembayaran diterima · Simpan'),
          ),
          const SizedBox(height: 14),
          const Center(
            child: Text(
              'Pencatatan lokal. Aplikasi tidak memproses pembayaran.',
              style: TextStyle(color: _muted, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

String receiptText(UmkmStore store, Sale sale) =>
    '${store.profile.businessName}\n${store.profile.address}\n${store.profile.phone}\n\n${sale.id}\n${formatDate(sale.date)} ${formatTime(sale.date)}\n${sale.items.map((i) => '${i.name}\n${i.quantity} x ${rupiah(i.price)} = ${rupiah(i.total)}').join('\n')}\n\nTOTAL: ${rupiah(sale.total)}\nPembayaran: ${sale.payment}\n\nTerima kasih sudah mendukung usaha lokal!';

class ReceiptScreen extends StatelessWidget {
  final UmkmStore store;
  final Sale sale;
  final bool justCreated;
  const ReceiptScreen({
    super.key,
    required this.store,
    required this.sale,
    this.justCreated = false,
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Bukti penjualan')),
    body: PageBody(
      maxWidth: 560,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F0DE),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: _green, size: 34),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            justCreated ? 'Penjualan berhasil dicatat.' : 'Detail penjualan',
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            justCreated
                ? 'Stok dan ringkasan usaha sudah diperbarui.'
                : formatDate(sale.date),
            style: const TextStyle(color: _muted, fontSize: 12),
          ),
        ),
        const SizedBox(height: 28),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  store.profile.businessName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                store.profile.address,
                textAlign: TextAlign.center,
                style: const TextStyle(color: _muted, fontSize: 11),
              ),
              const Divider(),
              Text(
                sale.id,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${formatDate(sale.date)} · ${formatTime(sale.date)}',
                style: const TextStyle(fontSize: 11, color: _muted),
              ),
              const SizedBox(height: 15),
              for (final item in sale.items)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${item.quantity} × ${rupiah(item.price)}',
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        rupiah(item.total),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              const Divider(),
              MoneyRow('Total', sale.total, bold: true),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Pembayaran',
                      style: TextStyle(color: _muted, fontSize: 12),
                    ),
                  ),
                  Pill(sale.payment),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Terima kasih sudah mendukung usaha lokal.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: _muted),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed:
              () => copyText(
                context,
                receiptText(store, sale),
                'Bukti penjualan disalin',
              ),
          icon: const Icon(Icons.copy_outlined, size: 18),
          label: const Text('Salin bukti penjualan'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Kembali ke ruang usaha'),
        ),
      ],
    ),
  );
}

class ExpenseFormScreen extends StatefulWidget {
  final UmkmStore store;
  const ExpenseFormScreen({super.key, required this.store});
  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final form = GlobalKey<FormState>();
  final amount = TextEditingController(), note = TextEditingController();
  String category = 'Operasional';
  late DateTime date = widget.store.clock();
  @override
  void dispose() {
    amount.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Catat pengeluaran')),
    body: PageBody(
      maxWidth: 620,
      children: [
        const PageHeading(
          eyebrow: 'Keuangan yang tertata',
          title: 'Biar tak ada yang terlewat.',
          subtitle:
              'Catat biaya operasional, transportasi, atau kebutuhan lainnya.',
        ),
        Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Kategori biaya',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: category,
                items:
                    [
                          'Operasional',
                          'Bahan Baku',
                          'Gaji',
                          'Transportasi',
                          'Lainnya',
                        ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (v) => setState(() => category = v!),
              ),
              if (category == 'Bahan Baku')
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Modal produk terjual sudah dihitung dari harga modal. Hindari mencatat biaya yang sama dua kali.',
                    style: TextStyle(fontSize: 11, color: _orange),
                  ),
                ),
              const SizedBox(height: 20),
              Field(
                'Nominal (Rp)',
                controller: amount,
                number: true,
                hint: '0',
                validator: positiveValidator,
              ),
              const Text(
                'Tanggal pengeluaran',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2000),
                    lastDate: widget.store.clock(),
                  );
                  if (selected != null && mounted) {
                    setState(() => date = selected);
                  }
                },
                icon: const Icon(Icons.calendar_today_outlined, size: 18),
                label: Text(formatDate(date)),
              ),
              const SizedBox(height: 20),
              Field(
                'Catatan',
                controller: note,
                hint: 'Contoh: Kemasan takeaway',
                lines: 3,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  if (!form.currentState!.validate()) return;
                  widget.store.addExpense(
                    category: category,
                    note: note.text.trim(),
                    amount: int.parse(amount.text),
                    date: date,
                  );
                  Navigator.pop(context);
                  showSnack(context, 'Pengeluaran berhasil dicatat');
                },
                icon: const Icon(Icons.check_rounded),
                label: const Text('Simpan pengeluaran'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
