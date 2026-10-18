part of '../main.dart';

class SettingsScreen extends StatelessWidget {
  final UmkmStore store;
  const SettingsScreen({super.key, required this.store});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder:
        (context, _) => PageBody(
          maxWidth: 920,
          children: [
            const PageHeading(
              eyebrow: 'Ruang milikmu',
              title: 'Usaha baik, berawal dari kamu.',
              subtitle: 'Atur identitas usaha dan jadikan ruang ini milikmu.',
            ),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          color: _forest,
                          borderRadius: BorderRadius.circular(21),
                        ),
                        child: const Icon(
                          Icons.storefront_outlined,
                          color: _lime,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              store.profile.businessName,
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              store.profile.ownerName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: _muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Pill(store.profile.category),
                      Pill(
                        store.isDemo ? 'Data contoh' : 'Usaha pribadi',
                        color: _muted,
                        background: _canvas,
                      ),
                    ],
                  ),
                  const Divider(),
                  _ContactRow(
                    Icons.location_on_outlined,
                    store.profile.address,
                  ),
                  const SizedBox(height: 10),
                  _ContactRow(Icons.phone_outlined, store.profile.phone),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed:
                        () => go(context, BusinessFormScreen(store: store)),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit informasi usaha'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            if (store.isDemo) ...[
              Panel(
                color: const Color(0xFFEAF0DF),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.spa_outlined, color: _green, size: 27),
                    const SizedBox(height: 15),
                    const Text(
                      'Siap menulis cerita usahamu?',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Saat ini kamu menggunakan data contoh Kafe Ayem. Buat ruang sendiri untuk memulai katalog dan transaksi dari kosong.',
                      style: TextStyle(fontSize: 13, color: _muted),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed:
                          () => go(
                            context,
                            BusinessFormScreen(store: store, startFresh: true),
                          ),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: const Text('Mulai usaha sendiri'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
            ],
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionHeading('Biar lebih terarah'),
                  SettingsRow(
                    icon: Icons.flag_outlined,
                    title: 'Target omzet bulanan',
                    subtitle: rupiah(store.monthlyTarget),
                    onTap: () => editTarget(context, store),
                  ),
                  SettingsRow(
                    icon: Icons.description_outlined,
                    title: 'Laporan & salin CSV',
                    subtitle: 'Ringkasan keuangan sesuai periode',
                    onTap: () => go(context, ReportScreen(store: store)),
                  ),
                  SettingsRow(
                    icon: Icons.notifications_none_rounded,
                    title: 'Pusat perhatian',
                    subtitle:
                        '${store.lowStock.length} produk perlu dicek stoknya',
                    onTap: () => go(context, AttentionScreen(store: store)),
                  ),
                  SettingsRow(
                    icon: Icons.auto_awesome_outlined,
                    title: 'Studio promosi',
                    subtitle: 'Template konten untuk produkmu',
                    onTap: () => go(context, MarketingScreen(store: store)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SectionHeading('Teman perjalanan usahamu'),
                  SettingsRow(
                    icon: Icons.help_outline_rounded,
                    title: 'Panduan singkat',
                    subtitle: 'Kenali alur kerja Ruang Usaha',
                    onTap: () => go(context, const GuideScreen()),
                  ),
                  SettingsRow(
                    icon: Icons.info_outline_rounded,
                    title: 'Tentang Ruang Usaha',
                    subtitle: 'UMKM Smart Assistant · versi 2.0',
                    onTap:
                        () => showAboutDialog(
                          context: context,
                          applicationName: 'Ruang Usaha',
                          applicationVersion: '2.0.0',
                          applicationIcon: const Icon(
                            Icons.spa_rounded,
                            color: _green,
                            size: 36,
                          ),
                          children: [
                            const Text(
                              'Teman mengelola usaha: katalog produk, pencatatan penjualan, pengeluaran, analisis, dan ide promosi. Dikembangkan sebagai UMKM Smart Assistant.',
                            ),
                          ],
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Panel(
              color: Color(0xFFEDF0E8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.devices_outlined, color: _green, size: 21),
                  SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ruang lokal, selalu dekat.',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Data disimpan di perangkat ini tanpa akun online. Salin laporan secara berkala sebelum menghapus aplikasi atau berpindah perangkat.',
                          style: TextStyle(fontSize: 12, color: _muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
  );
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ContactRow(this.icon, this.text);
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: _muted, size: 18),
      const SizedBox(width: 10),
      Expanded(
        child: Text(text, style: const TextStyle(fontSize: 12, color: _muted)),
      ),
    ],
  );
}

class SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: 4),
    leading: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _canvas,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(icon, color: _green, size: 20),
    ),
    title: Text(
      title,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    ),
    subtitle: Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: _muted),
      ),
    ),
    trailing: const Icon(Icons.chevron_right_rounded, color: _muted, size: 20),
    onTap: onTap,
  );
}

class BusinessFormScreen extends StatefulWidget {
  final UmkmStore store;
  final bool startFresh;
  const BusinessFormScreen({
    super.key,
    required this.store,
    this.startFresh = false,
  });
  @override
  State<BusinessFormScreen> createState() => _BusinessFormScreenState();
}

class _BusinessFormScreenState extends State<BusinessFormScreen> {
  final form = GlobalKey<FormState>();
  late final business = TextEditingController(
    text: widget.startFresh ? '' : widget.store.profile.businessName,
  );
  late final owner = TextEditingController(
    text: widget.startFresh ? '' : widget.store.profile.ownerName,
  );
  late final address = TextEditingController(
    text: widget.startFresh ? '' : widget.store.profile.address,
  );
  late final phone = TextEditingController(
    text: widget.startFresh ? '' : widget.store.profile.phone,
  );
  late String category =
      widget.startFresh ? 'Makanan & minuman' : widget.store.profile.category;
  @override
  void dispose() {
    for (final c in [business, owner, address, phone]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.startFresh ? 'Ruang usaha baru' : 'Informasi usaha'),
    ),
    body: PageBody(
      maxWidth: 620,
      children: [
        PageHeading(
          eyebrow: 'Kenalan dulu, yuk',
          title:
              widget.startFresh
                  ? 'Usahamu, ruangmu.'
                  : 'Identitas yang bercerita.',
          subtitle: 'Informasi ini akan muncul pada bukti penjualan.',
        ),
        Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Field(
                'Nama usaha',
                controller: business,
                hint: 'Contoh: Kedai Senja',
              ),
              Field('Nama pemilik', controller: owner, hint: 'Nama lengkapmu'),
              const Text(
                'Bidang usaha',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: category,
                items:
                    {
                          ...[
                            'Makanan & minuman',
                            'Fashion',
                            'Ritel',
                            'Jasa',
                            'Kerajinan',
                            'Lainnya',
                          ],
                          category,
                        }
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (v) => setState(() => category = v!),
              ),
              const SizedBox(height: 20),
              Field(
                'Alamat usaha',
                controller: address,
                hint: 'Jalan, nomor, dan kota',
                lines: 2,
              ),
              Field(
                'Nomor kontak',
                controller: phone,
                hint: '08xxxxxxxxxx',
                validator:
                    (value) =>
                        RegExp(
                              r'^[+\d][\d\s\-()]{6,18}$',
                            ).hasMatch(value?.trim() ?? '')
                            ? null
                            : 'Masukkan nomor kontak yang valid',
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () async {
                  if (!form.currentState!.validate()) return;
                  final profile = BusinessProfile(
                    businessName: business.text.trim(),
                    ownerName: owner.text.trim(),
                    category: category,
                    address: address.text.trim(),
                    phone: phone.text.trim(),
                  );
                  if (widget.startFresh) {
                    if (!await confirm(
                      context,
                      title: 'Mulai dengan ruang yang bersih?',
                      message:
                          'Katalog, transaksi, dan pengeluaran contoh akan dihapus. Informasi usahamu akan digunakan untuk ruang baru.',
                      button: 'Buat ruang usaha',
                    )) {
                      return;
                    }
                    if (!context.mounted) return;
                    widget.store.startOwnBusiness(profile);
                  } else {
                    widget.store.updateProfile(profile);
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                    showSnack(
                      context,
                      widget.startFresh
                          ? 'Selamat datang di ruang usahamu!'
                          : 'Informasi usaha berhasil diperbarui',
                    );
                  }
                },
                icon: const Icon(Icons.check_rounded),
                label: Text(
                  widget.startFresh ? 'Buat ruang usaha' : 'Simpan perubahan',
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class AttentionScreen extends StatelessWidget {
  final UmkmStore store;
  const AttentionScreen({super.key, required this.store});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder:
        (context, _) => Scaffold(
          appBar: AppBar(title: const Text('Pusat perhatian')),
          body: PageBody(
            maxWidth: 760,
            children: [
              const PageHeading(
                eyebrow: 'Selangkah lebih siap',
                title: 'Yang perlu kamu tahu.',
                subtitle: 'Pengingat langsung dari kondisi usahamu saat ini.',
              ),
              if (store.lowStock.isEmpty)
                const Panel(
                  child: EmptyView(
                    icon: Icons.check_circle_outline_rounded,
                    title: 'Semua persediaan aman.',
                    message: 'Belum ada produk yang mencapai batas minimum.',
                  ),
                ),
              for (final p in store.lowStock)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Panel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ProductArt(product: p),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    p.stock == 0
                                        ? 'Stok habis. Produk belum bisa dijual.'
                                        : 'Tersisa ${p.stock} unit · minimum ${p.minStock}',
                                    style: const TextStyle(
                                      color: _orange,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        OutlinedButton.icon(
                          onPressed: () => restockProduct(context, store, p),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Tambah stok'),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              TargetCard(store: store),
            ],
          ),
        ),
  );
}

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Panduan singkat')),
    body: const PageBody(
      maxWidth: 720,
      children: [
        PageHeading(
          eyebrow: 'Teman di setiap langkah',
          title: 'Mulai mudah, tumbuh terarah.',
          subtitle: 'Kenali lima langkah sederhana untuk mengelola usahamu.',
        ),
        Panel(
          child: Column(
            children: [
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text('01 · Kenalkan usahamu'),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: Text(
                      'Buka tab Usaha, lalu edit informasi usaha. Jika masih memakai data contoh, pilih Mulai usaha sendiri untuk memulai katalog dan transaksi dari kosong.',
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text('02 · Isi katalog produk'),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: Text(
                      'Tambahkan nama, kategori, harga modal, harga jual, dan stok. Atur batas stok minimum agar produk yang hampir habis muncul di Pusat perhatian.',
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text('03 · Catat penjualan'),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: Text(
                      'Pilih satu atau beberapa produk, tentukan jumlah, lalu tinjau pesanan. Setelah menerima pembayaran, pilih metode dan simpan. Stok otomatis berkurang. Bukti penjualan bisa disalin.',
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text('04 · Rapikan pengeluaran'),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: Text(
                      'Catat biaya operasional dan tanggalnya. Harga modal produk terjual sudah masuk perhitungan laba, jadi hindari mencatat biaya yang sama dua kali. Tambah stok hanya mengubah jumlah persediaan.',
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text('05 · Pelajari dan bertumbuh'),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: Text(
                      'Gunakan Analisis untuk melihat tren, produk favorit, dan laba bersih. Pilih periode laporan, salin CSV, dan buat ide konten di Studio promosi. Data disimpan di perangkat ini; laporan CSV membantu menyimpan catatan di luar aplikasi.',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
