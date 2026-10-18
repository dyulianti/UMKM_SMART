part of '../main.dart';

class DashboardScreen extends StatefulWidget {
  final UmkmStore store;
  final ValueChanged<int> openTab;
  const DashboardScreen({
    super.key,
    required this.store,
    required this.openTab,
  });
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  BusinessPeriod period = BusinessPeriod.today;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.store,
    builder: (context, _) {
      final store = widget.store;
      final summary = store.summary(period);
      final now = store.clock();
      return PageBody(
        children: [
          PageHeading(
            eyebrow: '${_days[now.weekday - 1]}, ${formatDate(now)}',
            title:
                '${greeting(now)}, ${store.profile.ownerName.split(' ').first}.',
            subtitle: 'Langkah kecil hari ini, usaha besar esok hari.',
            action:
                MediaQuery.sizeOf(context).width < 700
                    ? null
                    : FilledButton.icon(
                      onPressed: () => go(context, NewSaleScreen(store: store)),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Catat penjualan'),
                    ),
          ),
          if (store.isDemo)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Wrap(
                spacing: 9,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Pill('Ruang demo', icon: Icons.science_outlined),
                  TextButton(
                    onPressed: () => widget.openTab(4),
                    child: const Text(
                      'Data contoh Kafe Ayem · Atur usaha',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Ringkasan usahamu',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              if (MediaQuery.sizeOf(context).width >= 600)
                PeriodPicker(
                  value: period,
                  onChanged: (v) => setState(() => period = v),
                )
              else
                PopupMenuButton<BusinessPeriod>(
                  tooltip: 'Pilih periode ringkasan',
                  initialValue: period,
                  onSelected: (v) => setState(() => period = v),
                  itemBuilder:
                      (_) =>
                          BusinessPeriod.values
                              .map(
                                (p) => PopupMenuItem(
                                  value: p,
                                  child: Text(p.label),
                                ),
                              )
                              .toList(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          period.label,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _green,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.expand_more_rounded,
                          size: 17,
                          color: _green,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, c) {
              final hero = RevenueCard(summary: summary, period: period);
              final stats = Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      label: 'Laba bersih',
                      value: rupiah(summary.profit),
                      caption: 'Setelah modal & biaya',
                      icon: Icons.account_balance_wallet_outlined,
                      color: summary.profit >= 0 ? _green : _red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MetricCard(
                      label: 'Pengeluaran',
                      value: rupiah(summary.spending),
                      caption: '${summary.expenses.length} catatan biaya',
                      icon: Icons.north_east_rounded,
                      color: _orange,
                    ),
                  ),
                ],
              );
              return c.maxWidth >= 850
                  ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 5, child: hero),
                        const SizedBox(width: 18),
                        Expanded(flex: 6, child: stats),
                      ],
                    ),
                  )
                  : Column(children: [hero, const SizedBox(height: 12), stats]);
            },
          ),
          const SizedBox(height: 28),
          const SectionHeading('Mau mulai dari mana?'),
          LayoutBuilder(
            builder: (context, c) {
              final actions = [
                (
                  Icons.point_of_sale_rounded,
                  'Penjualan',
                  'Layani pesanan baru',
                  const Color(0xFFE8EFD9),
                  () => go(context, NewSaleScreen(store: store)),
                ),
                (
                  Icons.inventory_2_outlined,
                  'Tambah produk',
                  'Lengkapi katalogmu',
                  const Color(0xFFE7EEE9),
                  () => go(context, ProductFormScreen(store: store)),
                ),
                (
                  Icons.receipt_long_outlined,
                  'Pengeluaran',
                  'Catat biaya usaha',
                  const Color(0xFFF6ECD9),
                  () => go(context, ExpenseFormScreen(store: store)),
                ),
                (
                  Icons.auto_awesome_outlined,
                  'Studio promosi',
                  'Temukan ide konten',
                  const Color(0xFFEFE9F5),
                  () => go(context, MarketingScreen(store: store)),
                ),
              ];
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final a in actions)
                    SizedBox(
                      width:
                          (c.maxWidth - (c.maxWidth >= 650 ? 36 : 12)) /
                          (c.maxWidth >= 650 ? 4 : 2),
                      child: QuickAction(
                        icon: a.$1,
                        title: a.$2,
                        subtitle: a.$3,
                        background: a.$4,
                        onTap: a.$5,
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, c) {
              final chart = Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeading(
                      'Performa penjualan',
                      action: 'Lihat analisis ↗',
                      onTap: () => widget.openTab(3),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        Text(
                          rupiah(store.summary(BusinessPeriod.week).revenue),
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -.7,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Text(
                            '7 hari terakhir',
                            style: TextStyle(fontSize: 11, color: _muted),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    SalesChart(sales: store.sales, now: now),
                  ],
                ),
              );
              final target = TargetCard(store: store);
              return c.maxWidth >= 850
                  ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: chart),
                      const SizedBox(width: 20),
                      Expanded(flex: 4, child: target),
                    ],
                  )
                  : Column(
                    children: [chart, const SizedBox(height: 18), target],
                  );
            },
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, c) {
              final recent = Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeading(
                      'Transaksi terbaru',
                      action: 'Lihat semua ↗',
                      onTap: () => widget.openTab(2),
                    ),
                    if (store.sales.isEmpty)
                      const EmptyView(
                        icon: Icons.receipt_long_outlined,
                        title: 'Cerita usahamu dimulai di sini',
                        message:
                            'Catat penjualan pertama untuk melihat aktivitas.',
                      )
                    else
                      ...store.sales
                          .take(4)
                          .map(
                            (sale) => SaleTile(
                              sale: sale,
                              onTap:
                                  () => go(
                                    context,
                                    ReceiptScreen(store: store, sale: sale),
                                  ),
                            ),
                          ),
                  ],
                ),
              );
              final stock = Panel(
                color: const Color(0xFFF2EFDF),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 21,
                          color: _orange,
                        ),
                        const SizedBox(width: 9),
                        const Expanded(
                          child: Text(
                            'Perlu perhatian',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Pill(
                          '${store.lowStock.length}',
                          color: _orange,
                          background: const Color(0xFFE9E2C8),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      store.lowStock.isEmpty
                          ? 'Semua stok aman. Siap menyambut pesanan berikutnya!'
                          : 'Jaga produk favorit tetap tersedia untuk pelangganmu.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8A805E),
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final product in store.lowStock.take(3))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            ProductArt(product: product, size: 37),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Tersisa ${product.stock} unit',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: _orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Tambah stok ${product.name}',
                              onPressed:
                                  () => restockProduct(context, store, product),
                              icon: const Icon(
                                Icons.add_circle_outline,
                                size: 22,
                                color: _orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (store.lowStock.isNotEmpty)
                      TextButton(
                        onPressed:
                            () => go(context, AttentionScreen(store: store)),
                        child: const Text(
                          'Kelola persediaan  →',
                          style: TextStyle(fontSize: 12, color: _orange),
                        ),
                      ),
                  ],
                ),
              );
              return c.maxWidth >= 850
                  ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: recent),
                      const SizedBox(width: 20),
                      Expanded(flex: 4, child: stock),
                    ],
                  )
                  : Column(
                    children: [recent, const SizedBox(height: 18), stock],
                  );
            },
          ),
          const SizedBox(height: 27),
          const Center(
            child: Text(
              'Dirancang untuk usaha yang terus bertumbuh.',
              style: TextStyle(fontSize: 11, color: _muted),
            ),
          ),
        ],
      );
    },
  );
}

class RevenueCard extends StatelessWidget {
  final BusinessSummary summary;
  final BusinessPeriod period;
  const RevenueCard({super.key, required this.summary, required this.period});
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(22),
    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_forest, Color(0xFF295746)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: CustomPaint(
        painter: _OrbitPainter(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bar_chart_rounded, size: 19, color: _lime),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Omzet ${period.label.toLowerCase()}',
                      style: const TextStyle(
                        color: Color(0xFFDBE8DF),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Icon(Icons.north_east_rounded, color: _lime, size: 20),
                ],
              ),
              const SizedBox(height: 20),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  rupiah(summary.revenue),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.3,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 19),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _lime,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      '${summary.sales.length} transaksi',
                      style: const TextStyle(
                        color: _forest,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '${summary.units} produk terjual',
                    style: const TextStyle(
                      color: Color(0xFFC6D9CC),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _OrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withValues(alpha: .055)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
    for (var i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width + 10, size.height * .8),
        65 + i * 26,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) => false;
}

class MetricCard extends StatelessWidget {
  final String label, value, caption;
  final IconData icon;
  final Color color;
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.caption,
    required this.icon,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => Panel(
    padding: const EdgeInsets.all(19),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .09),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 15),
        Text(label, style: const TextStyle(fontSize: 12, color: _muted)),
        const SizedBox(height: 5),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              letterSpacing: -.6,
              color: color == _red ? _red : _ink,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(caption, style: const TextStyle(fontSize: 10, color: _muted)),
      ],
    ),
  );
}

class QuickAction extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final Color background;
  final VoidCallback onTap;
  const QuickAction({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.background,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(17),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          border: Border.all(color: _line),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, size: 21, color: _forest),
                ),
                const Spacer(),
                const Icon(Icons.north_east_rounded, size: 14, color: _muted),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 3),
            Text(subtitle, style: const TextStyle(color: _muted, fontSize: 10)),
          ],
        ),
      ),
    ),
  );
}

class TargetCard extends StatelessWidget {
  final UmkmStore store;
  const TargetCard({super.key, required this.store});
  @override
  Widget build(BuildContext context) {
    final revenue = store.summary(BusinessPeriod.month).revenue;
    final progress = revenue / store.monthlyTarget;
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(
            'Target bulan ini',
            action: 'Ubah',
            onTap: () => editTarget(context, store),
          ),
          Center(
            child: SizedBox(
              width: 126,
              height: 126,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: progress.clamp(0, 1),
                      strokeWidth: 10,
                      backgroundColor: const Color(0xFFF0F2E9),
                      color: _green,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(progress * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1,
                        ),
                      ),
                      const Text(
                        'tercapai',
                        style: TextStyle(fontSize: 11, color: _muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 23),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 6,
            children: [
              Text(
                compactMoney(revenue),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              Text(
                'dari ${compactMoney(store.monthlyTarget)}',
                style: const TextStyle(color: _muted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            progress >= 1
                ? 'Target tercapai. Saatnya rayakan progresmu!'
                : 'Masih ada peluang. Yuk, lanjutkan langkah baikmu!',
            style: const TextStyle(fontSize: 11, color: _muted),
          ),
        ],
      ),
    );
  }
}

class SalesChart extends StatelessWidget {
  final List<Sale> sales;
  final DateTime now;
  final BusinessPeriod period;
  const SalesChart({
    super.key,
    required this.sales,
    required this.now,
    this.period = BusinessPeriod.week,
  });
  @override
  Widget build(BuildContext context) {
    final start =
        period == BusinessPeriod.today
            ? BusinessPeriod.week.start(now)
            : period.start(now);
    final length =
        DateTime(now.year, now.month, now.day).difference(start).inDays + 1;
    final days = List.generate(
      length,
      (i) => DateTime(start.year, start.month, start.day + i),
    );
    final values =
        days
            .map(
              (date) => sales
                  .where(
                    (s) =>
                        s.date.year == date.year &&
                        s.date.month == date.month &&
                        s.date.day == date.day,
                  )
                  .fold<int>(0, (sum, s) => sum + s.total),
            )
            .toList();
    final peak = values.fold<int>(0, math.max);
    return Semantics(
      label:
          'Grafik penjualan ${formatDate(start)} sampai ${formatDate(now)}, nilai tertinggi ${rupiah(peak)}',
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 43,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _axisMoney(peak),
                        style: const TextStyle(color: _muted, fontSize: 9),
                      ),
                      Text(
                        _axisMoney(peak ~/ 2),
                        style: const TextStyle(color: _muted, fontSize: 9),
                      ),
                      const Text(
                        '0',
                        style: TextStyle(color: _muted, fontSize: 9),
                      ),
                    ],
                  ),
                ),
                Expanded(child: CustomPaint(painter: _SalesPainter(values))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 43),
            child: LayoutBuilder(
              builder: (context, c) {
                final tickCount = c.maxWidth < 260 ? 4 : 7;
                final indices = List.generate(
                  math.min(days.length, tickCount),
                  (i) =>
                      (i *
                              (days.length - 1) /
                              (math.min(days.length, tickCount) - 1).clamp(
                                1,
                                100,
                              ))
                          .round(),
                );
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final i in indices)
                      Text(
                        days.length <= 7
                            ? _days[days[i].weekday - 1]
                            : '${days[i].day}',
                        style: const TextStyle(color: _muted, fontSize: 9),
                      ),
                  ],
                );
              },
            ),
          ),
          if (peak == 0)
            const Padding(
              padding: EdgeInsets.only(top: 14),
              child: Text(
                'Belum ada penjualan pada periode ini.',
                style: TextStyle(color: _muted, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }

  String _axisMoney(int n) =>
      n >= 1000000
          ? '${(n / 1000000).toStringAsFixed(1)} jt'
          : n >= 1000
          ? '${n ~/ 1000} rb'
          : '$n';
}

class _SalesPainter extends CustomPainter {
  final List<int> values;
  _SalesPainter(this.values);
  @override
  void paint(Canvas canvas, Size size) {
    final grid =
        Paint()
          ..color = _line
          ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = 4 + (size.height - 8) * i / 3;
      for (double x = 0; x < size.width; x += 8) {
        canvas.drawLine(
          Offset(x, y),
          Offset(math.min(x + 3, size.width), y),
          grid,
        );
      }
    }
    final maxValue = math.max(1, values.fold<int>(0, math.max));
    final points = List.generate(
      values.length,
      (i) => Offset(
        values.length == 1
            ? size.width / 2
            : size.width * i / (values.length - 1),
        8 + (size.height - 18) * (1 - values[i] / maxValue),
      ),
    );
    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final mid = (previous.dx + current.dx) / 2;
      line.cubicTo(mid, previous.dy, mid, current.dy, current.dx, current.dy);
    }
    final area =
        Path.from(line)
          ..lineTo(points.last.dx, size.height)
          ..lineTo(points.first.dx, size.height)
          ..close();
    canvas.drawPath(
      area,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x403D8A63), Color(0x003D8A63)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = _green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    for (final p in points) {
      canvas.drawCircle(p, 3.5, Paint()..color = Colors.white);
      canvas.drawCircle(p, 2.3, Paint()..color = _green);
    }
  }

  @override
  bool shouldRepaint(covariant _SalesPainter oldDelegate) => true;
}
