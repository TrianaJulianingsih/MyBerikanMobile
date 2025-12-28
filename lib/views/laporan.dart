import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:myberikan/views/notification_service.dart';

class LaporanPage extends StatefulWidget {
  final String idKaryawan;
  final String nama;
  final String jabatan;

  const LaporanPage({
    super.key,
    required this.idKaryawan,
    required this.nama,
    required this.jabatan,
  });

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  String? bulanTerpilih;
  final TextEditingController tahunController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();

  final List<String> daftarBulan = const [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
  ];

  Future<void> _simpanLaporan() async {
    if (bulanTerpilih == null ||
        tahunController.text.isEmpty ||
        tanggalController.text.isEmpty) {
      return;
    }

    final laporanRef = FirebaseFirestore.instance
        .collection('laporan_cuti')
        .doc();

    await laporanRef.set({
      'id_laporan': laporanRef.id,
      'bulan': bulanTerpilih,
      'tahun': int.parse(tahunController.text),
      'tanggal_laporan': tanggalController.text,
      'created_at': FieldValue.serverTimestamp(),
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RiwayatLaporanPage(
          bulan: bulanTerpilih!,
          tahun: int.parse(tahunController.text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _background(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Membuat Laporan Cuti",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text("Bulan"),
                DropdownButtonFormField<String>(
                  value: bulanTerpilih,
                  decoration: _decoration(Colors.white),
                  hint: const Text("Pilih Bulan"),
                  items: daftarBulan
                      .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                      .toList(),
                  onChanged: (val) => setState(() => bulanTerpilih = val),
                ),
                const SizedBox(height: 20),
                const Text("Tahun"),
                TextField(
                  controller: tahunController,
                  keyboardType: TextInputType.number,
                  decoration: _decoration(
                    Colors.white,
                    hintText: "Contoh: 2025",
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Tanggal Laporan"),
                TextField(
                  controller: tanggalController,
                  readOnly: true,
                  decoration: _decoration(
                    Colors.white,
                    hintText: "Pilih Tanggal",
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035),
                    );
                    if (picked != null) {
                      tanggalController.text =
                          "${picked.day.toString().padLeft(2, '0')}/"
                          "${picked.month.toString().padLeft(2, '0')}/"
                          "${picked.year}";
                    }
                  },
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _simpanLaporan,
                    child: const Text("Simpan"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RiwayatLaporanPage extends StatelessWidget {
  final String bulan;
  final int tahun;

  const RiwayatLaporanPage({
    super.key,
    required this.bulan,
    required this.tahun,
  });

  int _bulanKeAngka() {
    const map = {
      "Januari": 1,
      "Februari": 2,
      "Maret": 3,
      "April": 4,
      "Mei": 5,
      "Juni": 6,
      "Juli": 7,
      "Agustus": 8,
      "September": 9,
      "Oktober": 10,
      "November": 11,
      "Desember": 12,
    };
    return map[bulan]!;
  }

  Future<void> _unduhExcel(List<QueryDocumentSnapshot> data) async {
    await Permission.storage.request();

    final excel = Excel.createExcel();
    final sheet = excel['Laporan'];
    excel.setDefaultSheet('Laporan');

    sheet.appendRow([
      TextCellValue('Nama'),
      TextCellValue('Jabatan'),
      TextCellValue('Tanggal Awal'),
      TextCellValue('Tanggal Akhir'),
      TextCellValue('Durasi'),
      TextCellValue('Status'),
    ]);

    for (var doc in data) {
      final d = doc.data() as Map<String, dynamic>;
      sheet.appendRow([
        TextCellValue(d['nama'] ?? ''),
        TextCellValue(d['jabatan'] ?? ''),
        TextCellValue(d['tgl_awal'] ?? ''),
        TextCellValue(d['tgl_akhir'] ?? ''),
        IntCellValue(d['durasi_cuti'] ?? 0),
        TextCellValue(d['status'] ?? ''),
      ]);
    }

    final bytes = excel.encode();
    if (bytes == null) {
      throw Exception('Excel encode gagal');
    }

    final file = File(
      '/storage/emulated/0/Download/Laporan_Cuti_${bulan}_$tahun.xlsx',
    );

    await file.writeAsBytes(bytes, flush: true);

    await NotificationService.showSuccess(
    'Laporan Berhasil Diunduh',
    'File tersimpan di folder Download',
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _background(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "$bulan $tahun",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('cuti')
                      .where('status', whereIn: ['Disetujui', 'Ditolak'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final filtered = snapshot.data!.docs.where((doc) {
                      final d = doc.data() as Map<String, dynamic>;
                      if (d['created_at'] == null) return false;
                      final tgl = (d['created_at'] as Timestamp).toDate();
                      return tgl.month == _bulanKeAngka() && tgl.year == tahun;
                    }).toList();

                    if (filtered.isEmpty) {
                      return const Center(child: Text("Tidak ada data cuti"));
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filtered.length,
                            itemBuilder: (context, i) {
                              final d =
                                  filtered[i].data() as Map<String, dynamic>;
                              return Card(
                                child: ListTile(
                                  title: Text(d['nama']),
                                  subtitle: Text(
                                    "${d['tgl_awal']} - ${d['tgl_akhir']}\nStatus: ${d['status']}",
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('cuti')
                                          .doc(filtered[i].id)
                                          .delete();
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.download),
                            label: const Text("Unduh Excel"),
                            onPressed: () => _unduhExcel(filtered),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _background({required Widget child}) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1485C7),
          Color.fromARGB(255, 194, 228, 247),
          Colors.white,
          Colors.white,
        ],
      ),
    ),
    child: Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 300,
          child: Opacity(
            opacity: 0.6,
            child: Image.asset("assets/images/motif.png", fit: BoxFit.cover),
          ),
        ),

        child,
      ],
    ),
  );
}

InputDecoration _decoration(Color color, {String? hintText}) {
  return InputDecoration(
    filled: true,
    fillColor: color,
    hintText: hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );
}
