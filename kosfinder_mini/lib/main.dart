import 'package:flutter/material.dart';

void main() {
  runApp(const KosFinderApp());
}

class KosFinderApp extends StatelessWidget {
  const KosFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KosFinder Mini',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const KosListPage(),
    );
  }
}

class Kos {
  const Kos({
    required this.id,
    required this.nama,
    required this.lokasi,
    required this.hargaPerBulan,
  });

  final int id;
  final String nama;
  final String lokasi;
  final String hargaPerBulan;
}

class KosListPage extends StatefulWidget {
  const KosListPage({super.key});

  static const List<Kos> kosList = [
    Kos(
      id: 1,
      nama: 'Kos Melati',
      lokasi: 'Jl. Cempaka, dekat kampus',
      hargaPerBulan: 'Rp 850.000',
    ),
    Kos(
      id: 2,
      nama: 'Pondok Asri',
      lokasi: 'Jl. Kenanga, pusat kota',
      hargaPerBulan: 'Rp 1.200.000',
    ),
    Kos(
      id: 3,
      nama: 'Kos Bintang',
      lokasi: 'Jl. Mawar, dekat halte',
      hargaPerBulan: 'Rp 950.000',
    ),
    Kos(
      id: 4,
      nama: 'Rumah Singgah',
      lokasi: 'Jl. Anggrek, area kampus',
      hargaPerBulan: 'Rp 1.500.000',
    ),
    Kos(
      id: 5,
      nama: 'Kos Damai',
      lokasi: 'Jl. Flamboyan, dekat pasar',
      hargaPerBulan: 'Rp 750.000',
    ),
    Kos(
      id: 6,
      nama: 'Paviliun Hijau',
      lokasi: 'Jl. Merpati, lingkungan tenang',
      hargaPerBulan: 'Rp 1.100.000',
    ),
  ];

  @override
  State<KosListPage> createState() => _KosListPageState();
}

class _KosListPageState extends State<KosListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<int> _favoriteKosIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredKos = KosListPage.kosList.where((kos) {
      return kos.nama.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('KosFinder Mini')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration:
                  const InputDecoration(
                    labelText: 'Cari nama kos',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ).copyWith(
                    suffixIcon: _searchQuery.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus pencarian',
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            icon: const Icon(Icons.clear),
                          ),
                  ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
            ),
          ),
          Expanded(
            child: filteredKos.isEmpty
                ? const Center(child: Text('Kos tidak ditemukan.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredKos.length,
                    itemBuilder: (context, index) {
                      final kos = filteredKos[index];
                      final isFavorite = _favoriteKosIds.contains(kos.id);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            kos.nama,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(kos.lokasi),
                                const SizedBox(height: 6),
                                Text('${kos.hargaPerBulan} / bulan'),
                              ],
                            ),
                          ),
                          trailing: IconButton(
                            tooltip: isFavorite
                                ? 'Hapus dari favorit'
                                : 'Tambahkan ke favorit',
                            onPressed: () {
                              setState(() {
                                if (isFavorite) {
                                  _favoriteKosIds.remove(kos.id);
                                } else {
                                  _favoriteKosIds.add(kos.id);
                                }
                              });
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
