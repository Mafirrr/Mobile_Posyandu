import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posyandu_mob/core/viewmodel/Anggota_viewmodel.dart';
import 'TambahAnggotaScreen.dart';

class AnggotaScreen extends StatefulWidget {
  const AnggotaScreen({Key? key}) : super(key: key);

  @override
  State<AnggotaScreen> createState() => _AnggotaScreenState();
}

class _AnggotaScreenState extends State<AnggotaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<AnggotaViewModel>();
    viewModel.fetchAnggota();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Anggota',
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        centerTitle: true,
        backgroundColor: const Color.from(alpha: 1, red: 0.129, green: 0.588, blue: 0.953),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari anggota...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<AnggotaViewModel>(
              builder: (context, vm, _) {
                if (vm.loading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (vm.error != null) {
                  return Center(child: Text('Error: ${vm.error}'));
                }

                final filteredList = vm.anggotaList.where((anggota) {
                  final nama = anggota['nama'].toLowerCase();
                  final nik = anggota['nik'].toLowerCase();
                  return nama.contains(_searchQuery) || nik.contains(_searchQuery);
                }).toList();

                if (filteredList.isEmpty) {
                  return Center(child: Text('Tidak ada data anggota yang sesuai'));
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  itemCount: filteredList.length,
                  separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
                  itemBuilder: (context, index) {
                    final anggota = filteredList[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        title: Text(
                          anggota['nama'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text('nik: ${anggota['nik']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit,
                                  color: const Color.from(
                                      alpha: 1, red: 0.129, green: 0.588, blue: 0.953)),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TambahAnggotaScreen(
                                      anggota: anggota,
                                      isEdit: true,
                                    ),
                                  ),
                                );
                                if (result == true) {
                                  vm.fetchAnggota();
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text('Konfirmasi'),
                                    content: Text(
                                        'Hapus anggota ${anggota['nama']}?'),
                                    actions: [
                                      TextButton(
                                        child: Text('Batal'),
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                      ),
                                      TextButton(
                                        child: Text('Hapus'),
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed == true) {
                                  await vm.deleteAnggota(anggota['id'].toString());
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.from(alpha: 1, red: 0.129, green: 0.588, blue: 0.953),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TambahAnggotaScreen(isEdit: false),
            ),
          );
          if (result == true) {
            context.read<AnggotaViewModel>().fetchAnggota();
          }
        },
      ),
    );
  }
}
