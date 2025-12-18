import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PengajuanCutiPage extends StatefulWidget {
  final String idKaryawan;
  const PengajuanCutiPage({super.key, required this.idKaryawan});

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

  XFile? _pickedImage;
  String? _buktiBase64;
  String? _fotoBase64;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadKaryawanById();
  }

  Future<void> _loadKaryawanById() async {
    final doc = await FirebaseFirestore.instance
        .collection('karyawan')
        .doc(widget.idKaryawan)
        .get();

    if (!doc.exists) return;
    final data = doc.data()!;

    setState(() {
      idController.text = widget.idKaryawan;
      namaController.text = data['nama'] ?? '';
      jabatanController.text = data['jabatan'] ?? '';
      _fotoBase64 = data['foto'];
    });
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _pickedImage = image;
        _buktiBase64 = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: _fotoBase64 != null
                        ? MemoryImage(base64Decode(_fotoBase64!))
                        : const AssetImage("assets/images/profile 1.png")
                              as ImageProvider,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Pengajuan Cuti",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              _label("ID Karyawan"),
              _field(idController),

              _label("Nama Lengkap"),
              _field(namaController),

              _label("Jabatan"),
              _field(jabatanController),

              _label("Tanggal Awal Cuti"),
              _field(tglAwalController, hint: "dd/mm/yyyy"),

              _label("Tanggal Akhir Cuti"),
              _field(tglAkhirController, hint: "dd/mm/yyyy"),

              _label("Alasan Cuti"),
              _field(alasanController, maxLines: 4),

              _label("Bukti Cuti"),
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1485C7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _pickImage,
                    icon: const Icon(Icons.photo_library, color: Colors.white),
                    label: const Text(
                      "Pilih Gambar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _pickedImage != null
                          ? _pickedImage!.name
                          : "Belum ada gambar",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Batal"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1485C7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (_buktiBase64 == null) return;

                      await FirebaseFirestore.instance.collection('cuti').add({
                        'id_karyawan': widget.idKaryawan,
                        'nama': namaController.text,
                        'jabatan': jabatanController.text,
                        'tgl_awal': tglAwalController.text,
                        'tgl_akhir': tglAkhirController.text,
                        'alasan': alasanController.text,
                        'bukti_base64': _buktiBase64,
                        'status': 'Dalam Proses',
                        'created_at': Timestamp.now(),
                      });

                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: const Text("Cuti berhasil ditambahkan!"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      "Ajukan",
                      style: TextStyle(color: Colors.white),
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

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 6),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  Widget _field(TextEditingController c, {String? hint, int maxLines = 1}) {
    return TextField(
      controller: c,
      readOnly:
          c == idController || c == namaController || c == jabatanController,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF6F6F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class RiwayatCutiPage extends StatelessWidget {
  final String idKaryawan;
  const RiwayatCutiPage({super.key, required this.idKaryawan});

  Color _statusColor(String s) {
    switch (s) {
      case "Disetujui":
        return Colors.green;
      case "Ditolak":
        return Colors.red;
      default:
        return Colors.orange;
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
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Opacity(
                  opacity: 0.6,
                  child: Image.asset(
                    "assets/images/motif.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Riwayat Cuti",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('cuti')
                          .where('id_karyawan', isEqualTo: idKaryawan)
                          .orderBy('created_at', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("Terjadi kesalahan saat memuat data"),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text("Belum ada riwayat cuti"),
                          );
                        }

                        return ListView(
                          padding: const EdgeInsets.all(16),
                          children: snapshot.data!.docs.map((doc) {
                            final d = doc.data() as Map<String, dynamic>;

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  d['alasan'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "${d['tgl_awal']} - ${d['tgl_akhir']}",
                                ),
                                trailing: Text(
                                  d['status'],
                                  style: TextStyle(
                                    color: _statusColor(d['status']),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
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
        backgroundColor: const Color(0xFF1485C7),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PengajuanCutiPage(idKaryawan: idKaryawan),
            ),
          );
        },
      ),
    );
  }
}
