part of '../main.dart';

class AnalysisScreen extends StatefulWidget {
  final UmkmStore store;
  const AnalysisScreen({super.key, required this.store});
  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  BusinessPeriod period = BusinessPeriod.week;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.store,
    builder: (context, _) {
      final store = widget.store;
      final data = store.summary(period);
      final ranking = <String, (String, int, int)>{};
      for (final sale in data.sales) {
        for (final i in sale.items) {
          final old = ranking[i.productId];
          ranking[i.productId] = (
            i.name,
            (old?.$2 ?? 0) + i.quantity,
            (old?.$3 ?? 0) + i.total,
          );
        }
      }
      final top =
          ranking.entries.toList()
            ..sort((a, b) => b.value.$2.compareTo(a.value.$2));
      return PageBody(
        children: [
          PageHeading(
            eyebrow: 'Kenali potensi usahamu',
            title: 'Dari angka, jadi arah.',
            subtitle: 'Pahami performa usaha dan temukan peluang berikutnya.',
            action: OutlinedButton.icon(
              onPressed:
                  () => go(
                    context,
                    ReportScreen(store: store, initialPeriod: period),
                  ),
              icon: const Icon(Icons.description_outlined, size: 18),
              label: const Text('Buka laporan'),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: PeriodPicker(
              value: period,
              onChanged: (v) => setState(() => period = v),
            ),
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder:
                (context, c) => Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    for (final item in [
                      (
                        'Omzet',
                        rupiah(data.revenue),
                        '${data.sales.length} transaksi tercatat',
                        Icons.bar_chart_rounded,
                        _green,
                      ),
                      (
                        'Laba bersih',
                        rupiah(data.profit),
                        'Setelah modal & biaya',
                        Icons.account_balance_wallet_outlined,
                        data.profit < 0 ? _red : _green,
                      ),
                      (
                        'Rata-rata transaksi',
                        rupiah(
                          data.sales.isEmpty
                              ? 0
                              : data.revenue ~/ data.sales.length,
                        ),
                        '${data.units} unit terjual',
                        Icons.shopping_bag_outlined,
                        _orange,
                      ),
                    ])
                      SizedBox(
                        width:
                            c.maxWidth >= 700
                                ? (c.maxWidth - 28) / 3
                                : c.maxWidth,
                        child: MetricCard(
                          label: item.$1,
                          value: item.$2,
                          caption: item.$3,
                          icon: item.$4,
                          color: item.$5,
                        ),
                      ),
                  ],
                ),
          ),
          const SizedBox(height: 24),
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading('Tren penjualan'),
                Text(
                  period == BusinessPeriod.today
                      ? 'Grafik 7 hari untuk melihat konteks penjualan hari ini.'
                      : '${formatDate(period.start(store.clock()))} – ${formatDate(store.clock())}',
                  style: const TextStyle(fontSize: 11, color: _muted),
                ),
                const SizedBox(height: 24),
                SalesChart(
                  sales: store.sales,
                  now: store.clock(),
                  period: period,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, c) {
              final products = Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SectionHeading('Produk paling diminati'),
                    if (top.isEmpty)
                      const EmptyView(
                        icon: Icons.emoji_events_outlined,
                        title: 'Panggung produk favoritmu',
                        message:
                            'Produk terlaris akan tampil setelah ada penjualan.',
                      ),
                    for (var i = 0; i < math.min(top.length, 5); i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Row(
                          children: [
                            Text(
                              '${i + 1}'.padLeft(2, '0'),
                              style: const TextStyle(
                                fontSize: 12,
                                color: _muted,
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (store.productById(top[i].key)
                                case final p?) ...[
                              ProductArt(product: p, size: 39),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    top[i].value.$1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    rupiah(top[i].value.$3),
                                    style: const TextStyle(
                                      color: _muted,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Pill('${top[i].value.$2} unit'),
                          ],
                        ),
                      ),
                  ],
                ),
              );
              final finance = Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SectionHeading('Ke mana uangmu mengalir?'),
                    MoneyRow('Omzet penjualan', data.revenue),
                    MoneyRow('Modal produk terjual', -data.costs),
                    MoneyRow('Biaya pengeluaran', -data.spending),
                    const Divider(),
                    MoneyRow(
                      'Laba bersih',
                      data.profit,
                      bold: true,
                      color: data.profit < 0 ? _red : _green,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Laba = omzet − modal produk terjual − biaya pengeluaran.',
                      style: TextStyle(fontSize: 11, color: _muted),
                    ),
                  ],
                ),
              );
              return c.maxWidth >= 800
                  ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: products),
                      const SizedBox(width: 20),
                      Expanded(child: finance),
                    ],
                  )
                  : Column(
                    children: [products, const SizedBox(height: 18), finance],
                  );
            },
          ),
          const SizedBox(height: 22),
          Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading('Metode pembayaran'),
                for (final method in ['Tunai', 'QRIS', 'Transfer'])
                  Builder(
                    builder: (context) {
                      final amount = data.sales
                          .where((e) => e.payment == method)
                          .fold<int>(0, (s, e) => s + e.total);
                      final ratio =
                          data.revenue == 0 ? 0.0 : amount / data.revenue;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Column(
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 12,
                              runSpacing: 5,
                              children: [
                                Text(
                                  method,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  '${rupiah(amount)} · ${(ratio * 100).round()}%',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: _muted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: ratio,
                                minHeight: 6,
                                backgroundColor: _canvas,
                                color: _green,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Panel(
            color: const Color(0xFFEAF0DF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Pill('RUANG IDE', icon: Icons.auto_awesome_outlined),
                const SizedBox(height: 14),
                const Text(
                  'Produk bagus pantas dikenal.',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ubah katalogmu jadi caption, slogan, atau ide konten dengan template siap pakai.',
                  style: TextStyle(fontSize: 13, color: _muted),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () => go(context, MarketingScreen(store: store)),
                  icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                  label: const Text('Buka studio promosi'),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

String _csvCell(String value) {
  final numeric = RegExp(r'^-?\d+$').hasMatch(value);
  final safe =
      !numeric && RegExp(r'^\s*[=+@\-]').hasMatch(value) ? "'$value" : value;
  return '"${safe.replaceAll('"', '""')}"';
}

String reportCsv(UmkmStore store, BusinessPeriod period) {
  final data = store.summary(period);
  final rows = <List<String>>[
    ['Laporan Ruang Usaha', store.profile.businessName],
    [
      'Periode',
      '${formatDate(period.start(store.clock()))} - ${formatDate(store.clock())}',
    ],
    ['Omzet', '${data.revenue}'],
    ['Modal produk terjual', '${data.costs}'],
    ['Pengeluaran', '${data.spending}'],
    ['Laba bersih', '${data.profit}'],
    [],
    [
      'Jenis',
      'Nomor',
      'Tanggal',
      'Keterangan',
      'Jumlah unit',
      'Nominal',
      'Pembayaran / kategori',
    ],
    for (final s in data.sales)
      [
        'Penjualan',
        s.id,
        s.date.toIso8601String(),
        s.productName,
        '${s.quantity}',
        '${s.total}',
        s.payment,
      ],
    for (final e in data.expenses)
      [
        'Pengeluaran',
        e.id,
        e.date.toIso8601String(),
        e.note,
        '',
        '${e.amount}',
        e.category,
      ],
  ];
  return rows.map((r) => r.map(_csvCell).join(',')).join('\r\n');
}

class ReportScreen extends StatefulWidget {
  final UmkmStore store;
  final BusinessPeriod initialPeriod;
  const ReportScreen({
    super.key,
    required this.store,
    this.initialPeriod = BusinessPeriod.month,
  });
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late BusinessPeriod period = widget.initialPeriod;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.store,
    builder: (context, _) {
      final data = widget.store.summary(period);
      return Scaffold(
        appBar: AppBar(title: const Text('Laporan usaha')),
        body: PageBody(
          maxWidth: 720,
          children: [
            const PageHeading(
              eyebrow: 'Semua lebih jelas',
              title: 'Gambaran besar usahamu.',
              subtitle:
                  'Ringkasan keuangan dari catatan penjualan dan pengeluaran.',
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: PeriodPicker(
                value: period,
                onChanged: (v) => setState(() => period = v),
              ),
            ),
            const SizedBox(height: 22),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.store.profile.businessName,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${formatDate(period.start(widget.store.clock()))} – ${formatDate(widget.store.clock())}',
                    style: const TextStyle(fontSize: 12, color: _muted),
                  ),
                  const Divider(),
                  MoneyRow('Omzet', data.revenue),
                  MoneyRow('Modal produk terjual', -data.costs),
                  MoneyRow('Pengeluaran', -data.spending),
                  const Divider(),
                  MoneyRow(
                    'Laba bersih',
                    data.profit,
                    bold: true,
                    color: data.profit < 0 ? _red : _green,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Pill('${data.sales.length} penjualan')),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Pill(
                          '${data.expenses.length} pengeluaran',
                          color: _orange,
                          background: const Color(0xFFF7F0DF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed:
                  () => copyText(
                    context,
                    reportCsv(widget.store, period),
                    'Laporan CSV disalin. Tempel ke file .csv atau spreadsheet.',
                  ),
              icon: const Icon(Icons.table_view_outlined, size: 19),
              label: const Text('Salin laporan CSV'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed:
                  () => copyText(
                    context,
                    '${widget.store.profile.businessName}\n${period.label}\nOmzet: ${rupiah(data.revenue)}\nModal: ${rupiah(data.costs)}\nPengeluaran: ${rupiah(data.spending)}\nLaba bersih: ${rupiah(data.profit)}',
                    'Ringkasan laporan disalin',
                  ),
              icon: const Icon(Icons.copy_outlined, size: 18),
              label: const Text('Salin ringkasan'),
            ),
            const SizedBox(height: 18),
            const Text(
              'CSV mencakup transaksi dalam periode terpilih. Nominal ditulis sebagai angka rupiah agar mudah diolah kembali.',
              style: TextStyle(fontSize: 11, color: _muted),
            ),
          ],
        ),
      );
    },
  );
}

class MarketingScreen extends StatefulWidget {
  final UmkmStore store;
  const MarketingScreen({super.key, required this.store});
  @override
  State<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen> {
  @override
  void initState() {
    super.initState();
    widget.store.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.store.removeListener(_refresh);
    super.dispose();
  }

  String? productId;
  String audience = 'Pelanggan umum', type = 'Caption';
  String? result;
  int variant = 0;
  @override
  Widget build(BuildContext context) {
    final product = widget.store.productById(productId ?? '');
    return Scaffold(
      appBar: AppBar(title: const Text('Studio promosi')),
      body: PageBody(
        maxWidth: 760,
        children: [
          Panel(
            color: const Color(0xFFECE8F2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.auto_awesome_outlined,
                  color: Color(0xFF7A648D),
                  size: 30,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ide segar untuk\ncerita usahamu.',
                  style: TextStyle(
                    fontSize: 30,
                    letterSpacing: -1,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Template promosi berdasarkan produk dan target pelanggan. Bisa dipakai offline, lalu sesuaikan dengan gayamu.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF85788F)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          if (widget.store.products.isEmpty)
            EmptyView(
              icon: Icons.inventory_2_outlined,
              title: 'Mulai dari produkmu',
              message: 'Tambahkan produk sebelum membuat konten promosi.',
              action: FilledButton(
                onPressed:
                    () => go(context, ProductFormScreen(store: widget.store)),
                child: const Text('Tambah produk'),
              ),
            )
          else ...[
            const Text(
              'Produk yang ingin dikenalkan',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: productId,
              isExpanded: true,
              hint: const Text('Pilih produk'),
              items:
                  widget.store.products
                      .map(
                        (p) =>
                            DropdownMenuItem(value: p.id, child: Text(p.name)),
                      )
                      .toList(),
              onChanged:
                  (v) => setState(() {
                    productId = v;
                    result = null;
                  }),
            ),
            const SizedBox(height: 20),
            const Text(
              'Siapa target pelangganmu?',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: audience,
              isExpanded: true,
              items:
                  [
                        'Pelanggan umum',
                        'Mahasiswa & anak muda',
                        'Keluarga',
                        'Pekerja kantoran',
                      ]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged:
                  (v) => setState(() {
                    audience = v!;
                    result = null;
                  }),
            ),
            const SizedBox(height: 22),
            const Text(
              'Mau buat apa hari ini?',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final item in [
                  'Caption',
                  'Deskripsi',
                  'Ide konten',
                  'Slogan',
                  'Promosi',
                ])
                  ChoiceChip(
                    showCheckmark: false,
                    selected: type == item,
                    label: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12,
                        color: type == item ? Colors.white : _muted,
                      ),
                    ),
                    onSelected:
                        (_) => setState(() {
                          type = item;
                          result = null;
                        }),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed:
                  product == null
                      ? null
                      : () => setState(() {
                        variant++;
                        result = marketingCopy(
                          product,
                          type,
                          audience,
                          variant,
                          widget.store.profile.businessName,
                        );
                      }),
              icon: const Icon(Icons.auto_awesome_outlined, size: 19),
              label: const Text('Buat ide konten'),
            ),
          ],
          if (result != null) ...[
            const SizedBox(height: 26),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Draf untukmu',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Pill(type),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SelectableText(
                    result!,
                    style: const TextStyle(fontSize: 15, height: 1.7),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed:
                              () => copyText(
                                context,
                                result!,
                                'Konten promosi berhasil disalin',
                              ),
                          icon: const Icon(Icons.copy_outlined, size: 17),
                          label: const Text('Salin'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed:
                              product == null
                                  ? null
                                  : () => setState(() {
                                    variant++;
                                    result = marketingCopy(
                                      product,
                                      type,
                                      audience,
                                      variant,
                                      widget.store.profile.businessName,
                                    );
                                  }),
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('Ide lainnya'),
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

String marketingCopy(
  Product p,
  String type,
  String audience,
  int variant,
  String business,
) {
  final openings = [
    'Ada yang baru untuk harimu.',
    'Pilihan kecil, bikin hari lebih berkesan.',
    'Saatnya kasih jeda untuk diri sendiri.',
  ];
  final opening = openings[variant % openings.length];
  return switch (type) {
    'Deskripsi' =>
      '$opening\n\nKenalan dengan ${p.name} dari $business. Pilihan ${p.category.toLowerCase()} untuk ${audience.toLowerCase()}, seharga ${rupiah(p.price)} per unit.\n\nHubungi kami untuk informasi dan pemesanan.',
    'Ide konten' =>
      [
        'Buat video 15 detik tentang ${p.name}:\n1. Buka dengan detail produk.\n2. Tampilkan proses persiapannya.\n3. Tambahkan harga ${rupiah(p.price)}.\n4. Ajak ${audience.toLowerCase()} berbagi pendapat di komentar.',
        'Ceritakan di balik layar $business:\n1. Perkenalkan orang di balik ${p.name}.\n2. Tunjukkan satu detail yang membuat produk ini spesial.\n3. Tutup dengan pertanyaan untuk ${audience.toLowerCase()}.',
        'Buat carousel tentang ${p.name}:\nSlide 1: $opening\nSlide 2: Foto produk dan cerita singkat.\nSlide 3: Harga ${rupiah(p.price)} dan cara pesan.',
      ][variant % 3],
    'Slogan' =>
      [
        '${p.name}, teman baik di setiap jeda.',
        '$business — cerita baik dimulai dari ${p.name}.',
        'Hari biasa, terasa istimewa bersama ${p.name}.',
      ][variant % 3],
    'Promosi' =>
      '$opening\n\n${p.name} dari $business siap menemani ${audience.toLowerCase()}.\nHarga: ${rupiah(p.price)} per unit.\n\nTertarik? Hubungi kami untuk cek ketersediaan dan pesan hari ini.\n\n#UsahaLokal #DukungUMKM',
    _ =>
      '$opening\n\nKenalan dengan ${p.name} dari $business. Cocok untuk ${audience.toLowerCase()} yang ingin mencoba sesuatu dari usaha lokal.\n\nMulai ${rupiah(p.price)} per unit. Yuk, tanyakan ketersediaannya dan pesan sekarang.\n\n#DukungUMKM #UsahaLokal',
  };
}
