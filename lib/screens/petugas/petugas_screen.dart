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

  Color primaryColor = const Color.fromARGB(255, 33, 150, 243);

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
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari Nama atau NIP...',
                prefixIcon: Icon(Icons.search, color: primaryColor),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD3D3D3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor),
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
                  return const Center(child: CircularProgressIndicator());
                }
                if (vm.error != null) {
                  return Center(child: Text('Error: ${vm.error}'));
                }

                final filteredList = vm.PetugasList.where((petugas) {
                  final role = petugas['role']?.toLowerCase() ?? '';
                  final nama = petugas['nama'].toLowerCase();
                  final nip = petugas['nip'].toLowerCase();

                  final matchesSearch =
                      nama.contains(_searchQuery) || nip.contains(_searchQuery);
                  final isBidan = role == 'bidan';

                  return isBidan && matchesSearch;
                }).toList();

                if (filteredList.isEmpty) {
                  return const Center(
                      child: Text('Tidak ada data petugas yang sesuai'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final petugas = filteredList[index];
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: primaryColor.withOpacity(0.2),
                          child: Icon(Icons.person, color: primaryColor),
                        ),
                        title: Text(
                          petugas['nama'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text('Email: ${petugas['email']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () async {
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
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: primaryColor),
                                ),
                                child: Icon(Icons.edit,
                                    color: primaryColor, size: 20),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Konfirmasi'),
                                    content: Text(
                                        'Hapus petugas ${petugas['nama']}?'),
                                    actions: [
                                      TextButton(
                                        child: const Text('Batal'),
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                      ),
                                      TextButton(
                                        child: const Text('Hapus'),
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed == true) {
                                  await vm
                                      .deletePetugas(petugas['id'].toString());
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: primaryColor),
                                ),
                                child: const Icon(Icons.delete,
                                    color: Colors.red, size: 20),
                              ),
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
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: primaryColor,
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
