import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/models/Anggota.dart';
import 'package:posyandu_mob/core/models/Jadwal.dart';
import 'package:posyandu_mob/core/models/Posyandu.dart';
import 'package:posyandu_mob/core/services/AnggotaService.dart';
import 'package:posyandu_mob/core/viewmodel/jadwalKader_viewmodel.dart';
import 'package:posyandu_mob/widgets/custom_tanggal.dart';
import 'package:posyandu_mob/widgets/custom_textfield.dart';

class JadwalPosyanduView extends StatefulWidget {
  const JadwalPosyanduView({Key? key}) : super(key: key);

  @override
  _JadwalPosyanduViewState createState() => _JadwalPosyanduViewState();
}

class _JadwalPosyanduViewState extends State<JadwalPosyanduView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _jamMulaiController = TextEditingController();
  final TextEditingController _jamSelesaiController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  DateTime? _tanggal;

  final JadwalkaderViewmodel _viewModel = JadwalkaderViewmodel();
  late Future<void> _loadFuture;
  List<Map<String, dynamic>> _posyanduList = [];
  int? _selectedPosyanduId;

  List<int> _anggotaIds = [];
  List<Anggota> anggotaList = [];
  List<Posyandu> posyanduList = [];

  Future<void> _loadAnggota() async {
    anggotaList = await AnggotaService().getAnggota();
    posyanduList = await AnggotaService().getPosyandu();
    setState(() {});
  }

  Future<void> _loadPosyandu() async {
    try {
      final data = await AnggotaService().fetchSuggestion();
      setState(() {
        _posyanduList = data;
      });
    } catch (e) {
      // tangani error
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFuture = _viewModel.loadJadwal();
    _loadAnggota();
    _loadPosyandu();
  }

  void _simpanJadwal() async {
    if (_anggotaIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Silakan pilih anggota terlebih dahulu")),
      );
      return;
    }

    if (_selectedPosyanduId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Silakan pilih posyandu")),
      );
      return;
    }

    if (_tanggal == null || _tanggalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tanggal wajib dipilih")),
      );
      return;
    }
    if (_formKey.currentState!.validate() && _tanggal != null) {
      final jadwalBaru = Jadwal(
        id: 0,
        judul: _judulController.text,
        tanggal: _tanggalController.text,
        lokasi: _selectedPosyanduId!,
        jam_mulai: _jamMulaiController.text,
        jam_selesai: _jamSelesaiController.text,
        yangMenghadiri: _anggotaIds,
        keterangan: null,
        anggota_id: null,
      );

      try {
        await _viewModel.addJadwal(jadwalBaru);

        _judulController.clear();
        _lokasiController.clear();
        _jamMulaiController.clear();
        _jamSelesaiController.clear();
        _tanggalController.clear();

        setState(() {
          _tanggal = null;
          _anggotaIds = [];
          _selectedPosyanduId = null;
          _loadFuture = _viewModel.loadJadwal();
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Jadwal berhasil disimpan')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan jadwal: $e')));
      }
    } else if (_tanggal == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Tanggal wajib dipilih')));
    }
  }

  void _editJadwal(Jadwal item) {
    final judulController = TextEditingController(text: item.judul);
    final lokasiController = TextEditingController(text: item.posyandu!.nama);
    _selectedPosyanduId = item.lokasi;
    final jamMulaiController = TextEditingController(text: item.jam_mulai);
    final jamSelesaiController = TextEditingController(text: item.jam_selesai);
    final tanggalController = TextEditingController(text: item.tanggal);
    DateTime? selectedDate = DateTime.tryParse(item.tanggal);
    _anggotaIds =
        (item.yangMenghadiri as List<dynamic>).map((e) => e as int).toList();
    String formatTimeTo24Hour(TimeOfDay time) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    final editFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Jadwal', style: TextStyle(fontSize: 14)),
        content: SingleChildScrollView(
          child: Form(
            key: editFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: judulController,
                  label: 'Judul',
                  fontSize: 12,
                  validator: (value) =>
                      value!.isEmpty ? 'Judul wajib diisi' : null,
                ),
                SizedBox(height: 8),
                _buildDropdownPosyandu(lokasiController),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          TimeOfDay? picked = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (picked != null) {
                            jamMulaiController.text =
                                formatTimeTo24Hour(picked);
                          }
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            controller: jamMulaiController,
                            decoration: InputDecoration(
                              labelText: 'Jam Mulai',
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                            ),
                            style: TextStyle(fontSize: 12),
                            validator: (value) =>
                                value!.isEmpty ? 'Wajib diisi' : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          TimeOfDay? picked = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (picked != null) {
                            jamSelesaiController.text =
                                formatTimeTo24Hour(picked);
                          }
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            controller: jamSelesaiController,
                            decoration: InputDecoration(
                              labelText: 'Jam Selesai',
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                            ),
                            style: TextStyle(fontSize: 12),
                            validator: (value) =>
                                value!.isEmpty ? 'Wajib diisi' : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                CustomTanggal(
                  controller: tanggalController,
                  hintText: "Tanggal Pelaksanaan",
                  value: selectedDate,
                  fontSize: 12,
                  onDateSelected: (date) {
                    selectedDate = date;
                    tanggalController.text =
                        DateFormat('yyyy-MM-dd').format(date);
                  },
                ),
                ElevatedButton(
                  onPressed: () => _showPilihAnggotaDialog('edit'),
                  child: Text(
                    _anggotaIds.isEmpty
                        ? 'Pilih Anggota yang Menghadiri'
                        : '${_anggotaIds.length} Anggota Terpilih',
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  _anggotaIds = [];
                  _selectedPosyanduId = null;
                });
                Navigator.pop(context);
              },
              child: Text('Batal', style: TextStyle(fontSize: 12))),
          ElevatedButton(
            onPressed: () async {
              if (editFormKey.currentState!.validate() &&
                  selectedDate != null) {
                final updated = Jadwal(
                  id: item.id,
                  judul: judulController.text,
                  tanggal: tanggalController.text,
                  lokasi: _selectedPosyanduId!,
                  jam_mulai: jamMulaiController.text,
                  jam_selesai: jamSelesaiController.text,
                  yangMenghadiri: _anggotaIds,
                  keterangan: item.keterangan,
                  anggota_id: item.anggota_id,
                );

                try {
                  await _viewModel.updateJadwal(updated);
                  setState(() {
                    _loadFuture = _viewModel.loadJadwal();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Jadwal berhasil diperbarui')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal update jadwal: $e')));
                }
              }
            },
            child: Text('Simpan', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle judulStyle = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);
    final TextStyle infoStyle =
        TextStyle(color: Colors.black.withAlpha(179), fontSize: 10);
    String formatTimeTo24Hour(TimeOfDay time) {
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pembuatan Jadwal",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _judulController,
                    label: 'Judul',
                    fontSize: 12,
                    validator: (value) =>
                        value!.isEmpty ? 'Judul wajib diisi' : null,
                  ),
                  SizedBox(height: 6),
                  _buildDropdownPosyandu(_lokasiController),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              _jamMulaiController.text =
                                  formatTimeTo24Hour(picked);
                            }
                          },
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: _jamMulaiController,
                              decoration: const InputDecoration(
                                labelText: 'Jam Mulai',
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                              style: const TextStyle(fontSize: 12),
                              validator: (value) =>
                                  value!.isEmpty ? 'Wajib diisi' : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              _jamSelesaiController.text =
                                  formatTimeTo24Hour(picked);
                            }
                          },
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: _jamSelesaiController,
                              decoration: InputDecoration(
                                labelText: 'Jam Selesai',
                                border: OutlineInputBorder(),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                              ),
                              style: TextStyle(fontSize: 12),
                              validator: (value) =>
                                  value!.isEmpty ? 'Wajib diisi' : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  CustomTanggal(
                    controller: _tanggalController,
                    hintText: "Tanggal Pelaksanaan",
                    value: _tanggal,
                    fontSize: 12,
                    onDateSelected: (selectedDate) {
                      setState(() {
                        _tanggal = selectedDate;
                        _tanggalController.text =
                            DateFormat('yyyy-MM-dd').format(selectedDate);
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: _showPilihAnggotaDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: BorderSide(color: Colors.blue),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        elevation: 0,
                      ),
                      child: Text(
                        _anggotaIds.isEmpty
                            ? 'Pilih Anggota yang Menghadiri'
                            : '${_anggotaIds.length} Anggota Terpilih',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: _simpanJadwal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 33, 150, 243),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Daftar Jadwal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            FutureBuilder<void>(
              future: _loadFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2)));
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          'Gagal memuat data jadwal.\nError: ${snapshot.error}',
                          style: TextStyle(fontSize: 12)));
                }

                if (_viewModel.jadwalList.isEmpty) {
                  return Center(
                      child: Text('Belum ada jadwal.',
                          style: TextStyle(fontSize: 12)));
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _viewModel.jadwalList.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = _viewModel.jadwalList[index];
                    final tanggal = DateFormat('dd-MM-yyyy')
                        .format(DateTime.parse(item.tanggal));

                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.judul,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.black)),
                                const SizedBox(height: 2),
                                Text("Lokasi: ${item.posyandu!.nama}",
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.black87)),
                                Text(
                                    "Jam: ${item.jam_mulai} - ${item.jam_selesai}",
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.black87)),
                                Text("Tanggal: $tanggal",
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.black87)),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => _editJadwal(item),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 33, 150, 243)),
                                  ),
                                  child: const Icon(Icons.edit,
                                      color: Color.fromARGB(255, 33, 150, 243),
                                      size: 20),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Konfirmasi'),
                                      content: const Text('Hapus jadwal ini?'),
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
                                    try {
                                      await _viewModel.deleteJadwal(item.id);
                                      setState(() {
                                        _loadFuture = _viewModel.loadJadwal();
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Jadwal berhasil dihapus')),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Gagal menghapus jadwal: $e')),
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 33, 150, 243)),
                                  ),
                                  child: const Icon(Icons.delete,
                                      color: Colors.red, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showPilihAnggotaDialog(String type) async {
    List<int> selectedIds = List.from(_anggotaIds);
    String selectedFilter = "semua";
    String keyword = "";

    final result = await showDialog<List<int>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredAnggota = anggotaList.where((anggota) {
              final cocokPosyandu = selectedFilter == "semua" ||
                  anggota.posyandu_id.toString() == selectedFilter;
              final cocokNamaNIK =
                  anggota.nama.toLowerCase().contains(keyword.toLowerCase()) ||
                      anggota.nik.toLowerCase().contains(keyword.toLowerCase());
              return cocokPosyandu && cocokNamaNIK;
            }).toList();

            return AlertDialog(
              title: const Text(
                "Pilih Anggota",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown filter Posyandu
                    DropdownButton<String>(
                      value: selectedFilter,
                      isExpanded: true,
                      underline: const SizedBox(),
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      items: [
                        const DropdownMenuItem(
                          value: "semua",
                          child: Text("Semua Posyandu"),
                        ),
                        ...posyanduList.map((p) => DropdownMenuItem(
                              value: p.id.toString(),
                              child: Text(p.nama),
                            )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedFilter = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 8),

                    // Search bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Cari Nama / NIK",
                        prefixIcon: const Icon(Icons.search, size: 20),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 14),
                      onChanged: (value) {
                        setState(() => keyword = value);
                      },
                    ),
                    const SizedBox(height: 8),

                    // Aksi Pilih semua / batal
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              for (var anggota in filteredAnggota) {
                                if (!selectedIds.contains(anggota.id)) {
                                  selectedIds.add(anggota.id);
                                }
                              }
                            });
                          },
                          child: const Text("Pilih Semua"),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedIds.removeWhere((id) =>
                                  filteredAnggota.any((a) => a.id == id));
                            });
                          },
                          child: const Text("Batal Pilih"),
                        ),
                      ],
                    ),
                    const Divider(height: 16),

                    // Daftar anggota
                    ...filteredAnggota.map((anggota) {
                      final isChecked = selectedIds.contains(anggota.id);
                      return Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  selectedIds.add(anggota.id);
                                } else {
                                  selectedIds.remove(anggota.id);
                                }
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              "${anggota.nama} (${anggota.nik})",
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (type == 'add') {
                      _anggotaIds = [];
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, selectedIds);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text("Simpan"),
                )
              ],
            );
          },
        );
      },
    );

    setState(() {
      _anggotaIds = result ?? [];
    });
  }

  Widget _buildDropdownPosyandu(TextEditingController controller) {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: 'Pilih Posyandu',
        border: OutlineInputBorder(),
      ),
      value: _selectedPosyanduId,
      items: _posyanduList.map((posyandu) {
        return DropdownMenuItem<int>(
          value: posyandu['id'],
          child: Text(posyandu['nama']),
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          _selectedPosyanduId = val;
          controller.text =
              _posyanduList.firstWhere((p) => p['id'] == val)['nama'];
        });
      },
      validator: (val) => val == null ? 'Lokasi wajib dipilih' : null,
    );
  }
}
