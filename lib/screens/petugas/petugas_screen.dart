import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posyandu_mob/core/viewmodel/Petugas_viewmodel.dart';
import 'TambahPetugasScreen.dart';

class PetugasScreen extends StatefulWidget {
  const PetugasScreen({Key? key}) : super(key: key);

  @override
  State<PetugasScreen> createState() => _PetugasScreenState();
}

class _PetugasScreenState extends State<PetugasScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<PetugasViewModel>();
    viewModel.fetchPetugas();
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
          'Daftar Petugas',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 150, 243), // contoh warna biru
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari petugas...',
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
            child: Consumer<PetugasViewModel>(
              builder: (context, vm, _) {
                if (vm.loading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (vm.error != null) {
                  return Center(child: Text('Error: ${vm.error}'));
                }

                final filteredList = vm.PetugasList.where((petugas) {
  final role = petugas['role']?.toLowerCase() ?? '';
  final nama = petugas['nama'].toLowerCase();
  final nip = petugas['nip'].toLowerCase();
  
  final matchesSearch = nama.contains(_searchQuery) || nip.contains(_searchQuery);
  final isBidan = role == 'bidan';

  return isBidan && matchesSearch;

                }).toList();

                if (filteredList.isEmpty) {
                  return Center(child: Text('Tidak ada data petugas yang sesuai'));
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  itemCount: filteredList.length,
                  separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
                  itemBuilder: (context, index) {
                    final petugas = filteredList[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        title: Text(
                          petugas['nama'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text('EMAIL: ${petugas['email']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit,
                                  color: const Color.fromARGB(255, 33, 150, 243)),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TambahPetugasScreen(
                                      petugas: petugas,
                                      isEdit: true,
                                    ),
                                  ),
                                );
                                if (result == true) {
                                  vm.fetchPetugas();
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
                                        'Hapus petugas ${petugas['nama']}?'),
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
                                  await vm.deletePetugas(petugas['id'].toString());
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
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TambahPetugasScreen(isEdit: false),
            ),
          );
          if (result == true) {
            context.read<PetugasViewModel>().fetchPetugas();
          }
        },
      ),
    );
  }
}
