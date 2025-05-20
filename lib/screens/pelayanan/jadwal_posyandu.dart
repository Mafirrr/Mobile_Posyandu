import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/models/Jadwal.dart';
import 'package:posyandu_mob/core/services/jadwalKader_service.dart';
import 'package:posyandu_mob/core/viewmodel/jadwalKader_viewmodel.dart';
import 'package:posyandu_mob/widgets/custom_button.dart';
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

  void _simpanJadwal() async {
    if (_formKey.currentState!.validate() && _tanggal != null) {
      final jadwalBaru = Jadwal(
        id: 0, // placeholder, akan diisi backend saat create
        judul: _judulController.text,
        tanggal: _tanggalController.text,
        lokasi: _lokasiController.text,
        jam_mulai: _jamMulaiController.text,
        jam_selesai: _jamSelesaiController.text,
        keterangan: null, // atau isi jika ada field keterangan
        anggota_id: null, // jika kamu belum pakai user login
      );

      try {
        await _viewModel
            .addJadwal(jadwalBaru); // simpan ke database dan list lokal

        // reset form setelah sukses
        _judulController.clear();
        _lokasiController.clear();
        _jamMulaiController.clear();
        _jamSelesaiController.clear();
        _tanggalController.clear();
        setState(() {
          _tanggal = null;
          _loadFuture = _viewModel.loadJadwal(); // update tampilan
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Jadwal berhasil disimpan')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan jadwal: $e')),
        );
      }
    } else if (_tanggal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tanggal wajib dipilih')),
      );
    }
  }

  void _editJadwal(Jadwal item) {
    final judulController = TextEditingController(text: item.judul);
    final lokasiController = TextEditingController(text: item.lokasi);
    final jamMulaiController = TextEditingController(text: item.jam_mulai);
    final jamSelesaiController = TextEditingController(text: item.jam_selesai);
    final tanggalController = TextEditingController(text: item.tanggal);
    DateTime? selectedDate = DateTime.tryParse(item.tanggal);

    final editFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Jadwal'),
          content: SingleChildScrollView(
            child: Form(
              key: editFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                    controller: judulController,
                    label: 'Judul',
                    validator: (value) =>
                        value!.isEmpty ? 'Judul wajib diisi' : null,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: lokasiController,
                    label: 'Lokasi',
                    validator: (value) =>
                        value!.isEmpty ? 'Lokasi wajib diisi' : null,
                  ),
                  SizedBox(height: 10),
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
                              jamMulaiController.text = picked.format(context);
                            }
                          },
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: jamMulaiController,
                              decoration: InputDecoration(
                                labelText: 'Jam Mulai',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Wajib diisi' : null,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              jamSelesaiController.text =
                                  picked.format(context);
                            }
                          },
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: jamSelesaiController,
                              decoration: InputDecoration(
                                labelText: 'Jam Selesai',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Wajib diisi' : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  CustomTanggal(
                    controller: tanggalController,
                    hintText: "Tanggal Pelaksanaan",
                    value: selectedDate,
                    onDateSelected: (date) {
                      selectedDate = date;
                      tanggalController.text =
                          DateFormat('yyyy-MM-dd').format(date);
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (editFormKey.currentState!.validate() &&
                    selectedDate != null) {
                  final updated = Jadwal(
                    id: item.id,
                    judul: judulController.text,
                    tanggal: tanggalController.text,
                    lokasi: lokasiController.text,
                    jam_mulai: jamMulaiController.text,
                    jam_selesai: jamSelesaiController.text,
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
                      SnackBar(content: Text('Jadwal berhasil diperbarui')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal update jadwal: $e')),
                    );
                  }
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadFuture = _viewModel.loadJadwal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pelayanan Posyandu'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Input
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Pembuatan Jadwal",
                          style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 16),
                      CustomTextField(
                        controller: _judulController,
                        label: 'Judul',
                        validator: (value) =>
                            value!.isEmpty ? 'Judul wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _lokasiController,
                        label: 'Lokasi',
                        validator: (value) =>
                            value!.isEmpty ? 'Lokasi wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
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
                                      picked.format(context);
                                }
                              },
                              child: IgnorePointer(
                                child: TextFormField(
                                  controller: _jamMulaiController,
                                  decoration: InputDecoration(
                                    labelText: 'Jam Mulai',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Wajib diisi' : null,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  _jamSelesaiController.text =
                                      picked.format(context);
                                }
                              },
                              child: IgnorePointer(
                                child: TextFormField(
                                  controller: _jamSelesaiController,
                                  decoration: InputDecoration(
                                    labelText: 'Jam Selesai',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      value!.isEmpty ? 'Wajib diisi' : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomTanggal(
                        controller: _tanggalController,
                        hintText: "Tanggal Pelaksanaan",
                        value: _tanggal,
                        onDateSelected: (selectedDate) {
                          setState(() {
                            _tanggal = selectedDate;
                            _tanggalController.text =
                                DateFormat('yyyy-MM-dd').format(selectedDate);
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.center,
                        child: CustomButton(
                          onPressed: _simpanJadwal,
                          text: 'Simpan',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Daftar Jadwal
            FutureBuilder<void>(
              future: _loadFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          'Gagal memuat data jadwal.\nError: ${snapshot.error}'));
                }

                if (_viewModel.jadwalList.isEmpty) {
                  return Center(child: Text('Belum ada jadwal.'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _viewModel.jadwalList.length,
                  itemBuilder: (context, index) {
                    final item = _viewModel.jadwalList[index];
                    final tanggal = DateFormat('dd-MM-yyyy').format(
                      DateTime.parse(item.tanggal),
                    );

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.judul,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Lokasi: ${item.lokasi}",
                              style: TextStyle(
                                color: const Color.fromARGB(179, 0, 0, 0),
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Jam: ${item.jam_mulai} - ${item.jam_selesai}",
                              style: TextStyle(
                                color: const Color.fromARGB(179, 0, 0, 0),
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Tanggal: $tanggal",
                              style: TextStyle(
                                color: const Color.fromARGB(179, 0, 0, 0),
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color: Colors.orangeAccent),
                                  onPressed: () {
                                     _editJadwal(item);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Konfirmasi Hapus'),
                                        content: Text(
                                            'Apakah kamu yakin ingin menghapus jadwal ini?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: Text('Hapus',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      try {
                                        await _viewModel.deleteJadwal(item.id);
                                        setState(() {
                                          _loadFuture = _viewModel.loadJadwal();
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
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
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
