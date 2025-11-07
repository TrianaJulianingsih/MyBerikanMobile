import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const PengajuanCutiApp());
}

class PengajuanCutiApp extends StatelessWidget {
  const PengajuanCutiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pengajuan Cuti',
      home: RiwayatCutiPage(),
    );
  }
}

class PengajuanCutiPage extends StatefulWidget {
  const PengajuanCutiPage({super.key});

  @override
  State<PengajuanCutiPage> createState() => _PengajuanCutiPageState();
}

class _PengajuanCutiPageState extends State<PengajuanCutiPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jabatanController = TextEditingController();
  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final TextEditingController alasanController = TextEditingController();

  File? _buktiFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _buktiFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/profile 1.png'),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Pengajuan Cuti",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              buildLabel("ID Karyawan"),
              buildTextField(idController, hint: "Masukkan ID Karyawan"),

              buildLabel("Nama Lengkap"),
              buildTextField(namaController, hint: "Masukkan nama lengkap"),

              buildLabel("Jabatan"),
              buildTextField(jabatanController, hint: "Masukkan jabatan"),

              buildLabel("Tanggal Awal Cuti"),
              buildTextField(tglAwalController, hint: "hh/mm/yyyy"),

              buildLabel("Tanggal Akhir Cuti"),
              buildTextField(tglAkhirController, hint: "hh/mm/yyyy"),

              buildLabel("Alasan Cuti"),
              buildTextField(
                alasanController,
                hint: "Alasan cuti",
                maxLines: 4,
              ),

              buildLabel("Bukti Cuti"),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Pilih Gambar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _buktiFile != null
                          ? _buktiFile!.path.split('/').last
                          : "Belum ada gambar",
                      style: TextStyle(
                        color: _buktiFile != null
                            ? Colors.black
                            : Colors.grey.shade600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (_buktiFile != null) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _buktiFile!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_buktiFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Harap pilih gambar bukti dulu."),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }

                      // Tampilkan pop-up konfirmasi dulu
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Data Terkirim!"),
                          content: const Text("Cuti anda berhasil diajukan."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context, {
                                  "hari": "Baru",
                                  "tgl":
                                      "${tglAwalController.text} - ${tglAkhirController.text}",
                                  "status": "Dalam Proses",
                                });
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      "Ajukan",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget buildTextField(
    TextEditingController controller, {
    String? hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF6F6F6),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class RiwayatCutiPage extends StatefulWidget {
  const RiwayatCutiPage({super.key});

  @override
  State<RiwayatCutiPage> createState() => _RiwayatCutiPageState();
}

class _RiwayatCutiPageState extends State<RiwayatCutiPage> {
  List<Map<String, String>> data = [
    {"hari": "Hari Ini", "tgl": "20/12/2025", "status": "Dalam Proses"},
    {"hari": "Jumat", "tgl": "08/06/2025", "status": "Ditolak"},
    {"hari": "Kamis", "tgl": "12/03/2025", "status": "Disetujui"},
    {"hari": "Senin", "tgl": "06/12/2024", "status": "Disetujui"},
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case "Disetujui":
        return Colors.green;
      case "Ditolak":
        return Colors.red;
      case "Dalam Proses":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  Future<void> _tambahCuti() async {
    final newData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PengajuanCutiPage()),
    );

    if (newData != null && newData is Map<String, String>) {
      setState(() {
        data.insert(0, newData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              height: 330,
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  "assets/images/motif.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const Spacer(),
                        const Text(
                          "Riwayat Cuti",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD2E9FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(item["hari"]!),
                            subtitle: Text(item["tgl"]!),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item["status"]!,
                                  style: TextStyle(
                                    color: getStatusColor(item["status"]!),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      data.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _tambahCuti,
        child: const Icon(Icons.add, color: Colors.blue),
      ),
    );
  }
}
