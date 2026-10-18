part of '../main.dart';

class BrandMark extends StatelessWidget {
  final bool large;
  const BrandMark({super.key, this.large = false});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: large ? 54 : 35,
        height: large ? 54 : 35,
        decoration: BoxDecoration(
          color: _forest,
          borderRadius: BorderRadius.circular(large ? 18 : 11),
        ),
        child: Icon(Icons.spa_rounded, color: _lime, size: large ? 30 : 21),
      ),
      const SizedBox(width: 10),
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ruang usaha',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: large ? 27 : 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -.7,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'TUMBUH LEBIH TERARAH',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: large ? 8 : 6.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.45,
                color: _muted,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class PageBody extends StatelessWidget {
  final List<Widget> children;
  final double maxWidth;
  const PageBody({super.key, required this.children, this.maxWidth = 1280});
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder:
        (context, c) => SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            c.maxWidth < 600 ? 20 : 32,
            28,
            c.maxWidth < 600 ? 20 : 32,
            32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ),
  );
}

class PageHeading extends StatelessWidget {
  final String eyebrow, title, subtitle;
  final Widget? action;
  const PageHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.action,
  });
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final text = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              color: _green,
              letterSpacing: 1.7,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: c.maxWidth < 500 ? 26 : 31,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -.9,
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: _muted, fontSize: 13)),
        ],
      );
      return Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child:
            c.maxWidth < 600 || action == null
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text,
                    if (action != null) ...[
                      const SizedBox(height: 17),
                      action!,
                    ],
                  ],
                )
                : Row(
                  children: [
                    Expanded(child: text),
                    const SizedBox(width: 20),
                    action!,
                  ],
                ),
      );
    },
  );
}

class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
    this.color = Colors.white,
  });
  @override
  Widget build(BuildContext context) => Material(
    color: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(22),
      side: BorderSide(
        color: color == Colors.white ? _line : Colors.transparent,
      ),
    ),
    child: Padding(padding: padding, child: child),
  );
}

class SectionHeading extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onTap;
  const SectionHeading(this.title, {super.key, this.action, this.onTap});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -.3,
            ),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(left: 8),
              minimumSize: const Size(44, 40),
            ),
            child: Text(action!, style: const TextStyle(fontSize: 11)),
          ),
      ],
    ),
  );
}

class Pill extends StatelessWidget {
  final String text;
  final Color color, background;
  final IconData? icon;
  const Pill(
    this.text, {
    super.key,
    this.color = _green,
    this.background = const Color(0xFFEDF4EA),
    this.icon,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    ),
  );
}

class PeriodPicker extends StatelessWidget {
  final BusinessPeriod value;
  final ValueChanged<BusinessPeriod> onChanged;
  const PeriodPicker({super.key, required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFECEFE6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final period in BusinessPeriod.values)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: TextButton(
                onPressed: () => onChanged(period),
                style: TextButton.styleFrom(
                  backgroundColor:
                      value == period ? Colors.white : Colors.transparent,
                  foregroundColor: value == period ? _forest : _muted,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  minimumSize: const Size(60, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: Text(
                  period.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        value == period ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool number;
  final int lines;
  final String? Function(String?)? validator;
  const Field(
    this.label, {
    super.key,
    required this.controller,
    this.hint,
    this.number = false,
    this.lines = 1,
    this.validator,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType:
              number
                  ? TextInputType.number
                  : (lines > 1 ? TextInputType.multiline : TextInputType.text),
          inputFormatters:
              number ? [FilteringTextInputFormatter.digitsOnly] : null,
          maxLines: lines,
          textInputAction:
              lines == 1 ? TextInputAction.next : TextInputAction.newline,
          decoration: InputDecoration(hintText: hint),
          validator: validator ?? requiredValidator,
        ),
      ],
    ),
  );
}

class EmptyView extends StatelessWidget {
  final IconData icon;
  final String title, message;
  final Widget? action;
  const EmptyView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              color: Color(0xFFEFF3E8),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 34, color: _green),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: _muted),
          ),
          if (action != null) ...[const SizedBox(height: 20), action!],
        ],
      ),
    ),
  );
}

class ProductArt extends StatelessWidget {
  final Product product;
  final double size;
  const ProductArt({super.key, required this.product, this.size = 52});
  @override
  Widget build(BuildContext context) {
    final name = product.name.toLowerCase();
    final (icon, tint, background) =
        name.contains('kopi')
            ? (
              Icons.coffee_rounded,
              const Color(0xFF927358),
              const Color(0xFFF0E7DA),
            )
            : name.contains('matcha')
            ? (
              Icons.local_cafe_rounded,
              const Color(0xFF738B43),
              const Color(0xFFEBF0D9),
            )
            : name.contains('brownies')
            ? (
              Icons.cake_rounded,
              const Color(0xFF92614C),
              const Color(0xFFF4E6DD),
            )
            : name.contains('cookies')
            ? (
              Icons.cookie_rounded,
              const Color(0xFFA88445),
              const Color(0xFFF5EEDC),
            )
            : name.contains('donat')
            ? (
              Icons.donut_large_rounded,
              const Color(0xFFB97E73),
              const Color(0xFFF5E7E1),
            )
            : product.category == 'Minuman'
            ? (
              Icons.local_drink_rounded,
              const Color(0xFF648A8D),
              const Color(0xFFE5EEEE),
            )
            : (
              Icons.bakery_dining_rounded,
              const Color(0xFFB58C50),
              const Color(0xFFF3EEDF),
            );
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(size * .25),
      ),
      child: Icon(icon, color: tint, size: size * .48),
    );
  }
}

class MoneyRow extends StatelessWidget {
  final String label;
  final int value;
  final bool bold;
  final Color? color;
  const MoneyRow(
    this.label,
    this.value, {
    super.key,
    this.bold = false,
    this.color,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: bold ? _ink : _muted,
              fontSize: 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            rupiah(value),
            textAlign: TextAlign.right,
            style: TextStyle(
              color: color ?? _ink,
              fontSize: bold ? 18 : 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

String? requiredValidator(String? value) =>
    value == null || value.trim().isEmpty ? 'Bagian ini perlu diisi' : null;
String? positiveValidator(String? value) =>
    (int.tryParse(value ?? '') ?? 0) < 1 ? 'Masukkan angka lebih dari 0' : null;
String? nonNegativeValidator(String? value) =>
    int.tryParse(value ?? '') == null || int.parse(value!) < 0
        ? 'Masukkan angka 0 atau lebih'
        : null;
String rupiah(int value) =>
    '${value < 0 ? '-' : ''}Rp${value.abs().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
String compactMoney(int value) =>
    value >= 1000000
        ? 'Rp${(value / 1000000).toStringAsFixed(1).replaceAll('.', ',')} jt'
        : rupiah(value);
String initials(String value) =>
    value
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .take(2)
        .map((e) => e.characters.first.toUpperCase())
        .join();
const _months = [
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
const _days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
String formatDate(DateTime date) =>
    '${date.day} ${_months[date.month - 1]} ${date.year}';
String formatTime(DateTime date) =>
    '${date.hour.toString().padLeft(2, '0')}.${date.minute.toString().padLeft(2, '0')}';
String greeting(DateTime date) =>
    date.hour < 11
        ? 'Selamat pagi'
        : date.hour < 15
        ? 'Selamat siang'
        : date.hour < 18
        ? 'Selamat sore'
        : 'Selamat malam';
void go(BuildContext context, Widget page) =>
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

Future<void> copyText(
  BuildContext context,
  String value,
  String message,
) async {
  try {
    await Clipboard.setData(ClipboardData(text: value));
    if (context.mounted) showSnack(context, message);
  } catch (_) {
    if (context.mounted) {
      showSnack(context, 'Belum dapat menyalin. Silakan coba lagi.');
    }
  }
}

Future<bool> confirm(
  BuildContext context, {
  required String title,
  required String message,
  String button = 'Lanjutkan',
  bool destructive = false,
}) async =>
    await showDialog<bool>(
      context: context,
      builder:
          (c) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: const Text('Batal'),
              ),
              FilledButton(
                style:
                    destructive
                        ? FilledButton.styleFrom(backgroundColor: _red)
                        : null,
                onPressed: () => Navigator.pop(c, true),
                child: Text(button),
              ),
            ],
          ),
    ) ??
    false;

Future<void> editTarget(BuildContext context, UmkmStore store) async {
  final controller = TextEditingController(
    text: store.monthlyTarget.toString(),
  );
  final form = GlobalKey<FormState>();
  final value = await showDialog<int>(
    context: context,
    builder:
        (c) => AlertDialog(
          title: const Text('Setiap langkah punya tujuan.'),
          content: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tentukan target omzet bulanan usahamu.',
                  style: TextStyle(color: _muted, fontSize: 13),
                ),
                const SizedBox(height: 20),
                Field(
                  'Target omzet (Rp)',
                  controller: controller,
                  number: true,
                  validator: positiveValidator,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                if (form.currentState!.validate()) {
                  Navigator.pop(c, int.parse(controller.text));
                }
              },
              child: const Text('Simpan target'),
            ),
          ],
        ),
  );
  if (value != null) store.setTarget(value);
  // Let the closing route finish before disposing field controllers.
  await Future<void>.delayed(const Duration(milliseconds: 300));
  controller.dispose();
}

Future<void> restockProduct(
  BuildContext context,
  UmkmStore store,
  Product product,
) async {
  final controller = TextEditingController(text: '10');
  final form = GlobalKey<FormState>();
  final quantity = await showDialog<int>(
    context: context,
    builder:
        (c) => AlertDialog(
          title: const Text('Tambah stok'),
          content: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Stok saat ini: ${product.stock} unit',
                  style: const TextStyle(color: _muted, fontSize: 13),
                ),
                const SizedBox(height: 20),
                Field(
                  'Jumlah stok masuk',
                  controller: controller,
                  number: true,
                  validator: positiveValidator,
                ),
                const Text(
                  'Catat biaya pembelian secara terpisah jika diperlukan.',
                  style: TextStyle(fontSize: 11, color: _muted),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                if (form.currentState!.validate()) {
                  Navigator.pop(c, int.parse(controller.text));
                }
              },
              child: const Text('Tambah stok'),
            ),
          ],
        ),
  );
  if (quantity != null) {
    store.restock(product.id, quantity);
    if (context.mounted) {
      showSnack(context, 'Stok ${product.name} bertambah $quantity unit');
    }
  }
  await Future<void>.delayed(const Duration(milliseconds: 300));
  controller.dispose();
}
