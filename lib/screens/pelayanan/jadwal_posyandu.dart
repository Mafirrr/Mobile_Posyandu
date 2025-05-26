import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posyandu_mob/core/models/Jadwal.dart';
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

  @override
  void initState() {
    super.initState();
    _loadFuture = _viewModel.loadJadwal();
  }

  void _simpanJadwal() async {
    if (_formKey.currentState!.validate() && _tanggal != null) {
      final jadwalBaru = Jadwal(
        id: 0,
        judul: _judulController.text,
        tanggal: _tanggalController.text,
        lokasi: _lokasiController.text,
        jam_mulai: _jamMulaiController.text,
        jam_selesai: _jamSelesaiController.text,
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
    final lokasiController = TextEditingController(text: item.lokasi);
    final jamMulaiController = TextEditingController(text: item.jam_mulai);
    final jamSelesaiController = TextEditingController(text: item.jam_selesai);
    final tanggalController = TextEditingController(text: item.tanggal);
    DateTime? selectedDate = DateTime.tryParse(item.tanggal);

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
              children: [
                CustomTextField(
                  controller: judulController,
                  label: 'Judul',
                  fontSize: 12,
                  validator: (value) =>
                      value!.isEmpty ? 'Judul wajib diisi' : null,
                ),
                SizedBox(height: 8),
                CustomTextField(
                  controller: lokasiController,
                  label: 'Lokasi',
                  fontSize: 12,
                  validator: (value) =>
                      value!.isEmpty ? 'Lokasi wajib diisi' : null,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          TimeOfDay? picked = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
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
                            jamSelesaiController.text = picked.format(context);
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
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: TextStyle(fontSize: 12))),
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
                  CustomTextField(
                    controller: _lokasiController,
                    label: 'Lokasi',
                    fontSize: 12,
                    validator: (value) =>
                        value!.isEmpty ? 'Lokasi wajib diisi' : null,
                  ),
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
                              _jamMulaiController.text = picked.format(context);
                            }
                          },
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: _jamMulaiController,
                              decoration: InputDecoration(
                                labelText: 'Jam Mulai',
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
                      SizedBox(width: 12),
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
                  SizedBox(height: 12),
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
            SizedBox(height: 20),
            Text(
              'Daftar Jadwal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            FutureBuilder<void>(
              future: _loadFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.black)),
                                SizedBox(height: 2),
                                Text("Lokasi: ${item.lokasi}",
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.black87)),
                                Text(
                                    "Jam: ${item.jam_mulai} - ${item.jam_selesai}",
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.black87)),
                                Text("Tanggal: $tanggal",
                                    style: TextStyle(
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
}
