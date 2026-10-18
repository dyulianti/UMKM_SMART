import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/store.dart';
export 'data/store.dart';

part 'ui/components.dart';
part 'ui/dashboard.dart';
part 'ui/catalog.dart';
part 'ui/transactions.dart';
part 'ui/insights.dart';
part 'ui/settings.dart';

const _forest = Color(0xFF183D35);
const _green = Color(0xFF32765E);
const _lime = Color(0xFFD9F279);
const _ink = Color(0xFF203830);
const _muted = Color(0xFF78837C);
const _canvas = Color(0xFFF6F7F2);
const _line = Color(0xFFE7EBE3);
const _orange = Color(0xFFB77928);
const _red = Color(0xFFBD5550);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const UmkmSmartAssistant());
}

ThemeData appTheme() => ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: _canvas,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _green,
    primary: _forest,
    secondary: _green,
    surface: Colors.white,
    error: _red,
  ),
  fontFamily: 'Roboto',
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: _ink, fontSize: 14, height: 1.45),
    bodyLarge: TextStyle(color: _ink, fontSize: 16, height: 1.45),
    titleLarge: TextStyle(
      color: _ink,
      fontWeight: FontWeight.w700,
      fontSize: 22,
    ),
    titleMedium: TextStyle(
      color: _ink,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    labelLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: _canvas,
    foregroundColor: _ink,
    surfaceTintColor: Colors.transparent,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: _ink,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    hintStyle: const TextStyle(color: _muted, fontSize: 14),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: _line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: _line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: _green, width: 1.5),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      side: const BorderSide(color: _line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: Colors.white,
    selectedColor: _forest,
    side: const BorderSide(color: _line),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: _forest,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  dividerTheme: const DividerThemeData(color: _line, thickness: 1, space: 28),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _forest,
    foregroundColor: _lime,
  ),
);

class UmkmSmartAssistant extends StatefulWidget {
  final UmkmStore? store;
  const UmkmSmartAssistant({super.key, this.store});
  @override
  State<UmkmSmartAssistant> createState() => _UmkmSmartAssistantState();
}

class _UmkmSmartAssistantState extends State<UmkmSmartAssistant> {
  late final UmkmStore store = widget.store ?? UmkmStore();
  bool loading = true;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.store == null) await store.load();
    if (mounted) setState(() => loading = false);
  }

  @override
  void dispose() {
    if (widget.store == null) store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Ruang Usaha · UMKM Smart Assistant',
    debugShowCheckedModeBanner: false,
    theme: appTheme(),
    home:
        loading
            ? const Scaffold(body: Center(child: BrandMark(large: true)))
            : store.loadFailed
            ? Scaffold(
              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: EmptyView(
                    icon: Icons.folder_off_outlined,
                    title: 'Data lokal belum bisa dibuka',
                    message:
                        'Data sebelumnya tetap disimpan. Coba baca kembali untuk melanjutkan.',
                    action: FilledButton(
                      onPressed: () {
                        setState(() => loading = true);
                        _load();
                      },
                      child: const Text('Coba kembali'),
                    ),
                  ),
                ),
              ),
            )
            : MainShell(store: store),
  );
}

class MainShell extends StatefulWidget {
  final UmkmStore store;
  const MainShell({super.key, required this.store});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;
  static const labels = ['Beranda', 'Produk', 'Transaksi', 'Analisis', 'Usaha'];
  static const icons = [
    Icons.space_dashboard_outlined,
    Icons.inventory_2_outlined,
    Icons.receipt_long_outlined,
    Icons.insights_outlined,
    Icons.storefront_outlined,
  ];
  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1000;
    final pages = [
      DashboardScreen(
        store: widget.store,
        openTab: (value) => setState(() => index = value),
      ),
      ProductsScreen(store: widget.store),
      TransactionScreen(store: widget.store),
      AnalysisScreen(store: widget.store),
      SettingsScreen(store: widget.store),
    ];
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (wide)
              Container(
                width: 238,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(right: BorderSide(color: _line)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BrandMark(),
                    const SizedBox(height: 42),
                    const Padding(
                      padding: EdgeInsets.only(left: 15, bottom: 14),
                      child: Text(
                        'RUANG KERJA',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 10,
                          letterSpacing: 1.8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    for (var i = 0; i < labels.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Material(
                          color: index == i ? _forest : Colors.transparent,
                          borderRadius: BorderRadius.circular(13),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            leading: Icon(
                              icons[i],
                              size: 21,
                              color: index == i ? _lime : _muted,
                            ),
                            title: Text(
                              labels[i],
                              style: TextStyle(
                                fontSize: 14,
                                color: index == i ? Colors.white : _muted,
                                fontWeight:
                                    index == i
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                              ),
                            ),
                            onTap: () => setState(() => index = i),
                          ),
                        ),
                      ),
                    const Spacer(),
                    if (MediaQuery.sizeOf(context).height >= 850)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _canvas,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.auto_awesome_outlined,
                              color: _green,
                              size: 23,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Ide segar, usaha mekar.',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Siapkan konten promosi dalam beberapa langkah.',
                              style: TextStyle(color: _muted, fontSize: 12),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed:
                                  () => go(
                                    context,
                                    MarketingScreen(store: widget.store),
                                  ),
                              child: const Text('Buka studio  ↗'),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 22),
                    const Row(
                      children: [
                        Icon(Icons.cloud_off_outlined, size: 16, color: _muted),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tersimpan di perangkat ini',
                            style: TextStyle(fontSize: 11, color: _muted),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Expanded(
              child: AnimatedBuilder(
                animation: widget.store,
                builder:
                    (context, _) => Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: wide ? 32 : 20,
                            vertical: wide ? 20 : 15,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(bottom: BorderSide(color: _line)),
                          ),
                          child: Row(
                            children: [
                              if (!wide)
                                const Expanded(child: BrandMark())
                              else
                                Text(
                                  labels[index],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              if (wide) const Spacer(),
                              if (wide) ...[
                                const Icon(
                                  Icons.storefront_outlined,
                                  size: 18,
                                  color: _muted,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.store.profile.businessName,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(width: 20),
                                Container(width: 1, height: 25, color: _line),
                                const SizedBox(width: 15),
                              ],
                              IconButton(
                                tooltip: 'Pusat perhatian',
                                visualDensity: VisualDensity.compact,
                                onPressed:
                                    () => go(
                                      context,
                                      AttentionScreen(store: widget.store),
                                    ),
                                icon: Badge(
                                  isLabelVisible:
                                      widget.store.lowStock.isNotEmpty,
                                  smallSize: 7,
                                  backgroundColor: _orange,
                                  child: const Icon(
                                    Icons.notifications_none_rounded,
                                    color: _ink,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 7),
                              InkWell(
                                onTap: () => setState(() => index = 4),
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF0E8),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Text(
                                    initials(widget.store.profile.ownerName),
                                    style: const TextStyle(
                                      color: _forest,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.store.storageError != null)
                          MaterialBanner(
                            content: Text(
                              widget.store.storageError!,
                              style: const TextStyle(fontSize: 12),
                            ),
                            actions: [
                              TextButton(
                                onPressed: widget.store.retrySave,
                                child: const Text('Coba lagi'),
                              ),
                            ],
                          ),
                        Expanded(
                          child: IndexedStack(index: index, children: pages),
                        ),
                      ],
                    ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          !wide && index == 0
              ? FloatingActionButton.extended(
                onPressed:
                    () => go(context, NewSaleScreen(store: widget.store)),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Penjualan'),
              )
              : null,
      bottomNavigationBar:
          wide
              ? null
              : NavigationBar(
                selectedIndex: index,
                onDestinationSelected: (value) => setState(() => index = value),
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                indicatorColor: const Color(0xFFE7EFCF),
                height: 72,
                labelTextStyle: WidgetStateProperty.resolveWith(
                  (states) => TextStyle(
                    fontSize: 10,
                    fontWeight:
                        states.contains(WidgetState.selected)
                            ? FontWeight.w700
                            : FontWeight.w500,
                    color:
                        states.contains(WidgetState.selected)
                            ? _forest
                            : _muted,
                  ),
                ),
                destinations: [
                  for (var i = 0; i < labels.length; i++)
                    NavigationDestination(
                      icon: Icon(icons[i], size: 22),
                      label: labels[i],
                    ),
                ],
              ),
    );
  }
}
