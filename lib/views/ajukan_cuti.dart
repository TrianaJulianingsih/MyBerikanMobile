import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myberikan/controllers/auth_cuti.dart';
import 'package:intl/intl.dart';

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
  final FirestoreServiceCuti _cutiService = FirestoreServiceCuti();

  @override
  void initState() {
    super.initState();
    _loadKaryawanById();
  }

  int hitungDurasi(String tglAwal, String tglAkhir) {
    try {
      final format = DateFormat('dd/MM/yyyy');

      DateTime start = format.parse(tglAwal);
      DateTime end = format.parse(tglAkhir);

      int durasi = end.difference(start).inDays + 1;

      return durasi < 0 ? 0 : durasi;
    } catch (e) {
      return 0;
    }
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
      namaController.text = data['username'] ?? '';
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

  int hitungDurasiHari(String tglAwal, String tglAkhir) {
    try {
      final startParts = tglAwal.split('/');
      final endParts = tglAkhir.split('/');

      final startDate = DateTime(
        int.parse(startParts[2]),
        int.parse(startParts[1]),
        int.parse(startParts[0]),
      );

      final endDate = DateTime(
        int.parse(endParts[2]),
        int.parse(endParts[1]),
        int.parse(endParts[0]),
      );

      return endDate.difference(startDate).inDays + 1;
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: _fotoBase64 != null
                        ? MemoryImage(base64Decode(_fotoBase64!))
                        : AssetImage("assets/images/profile 1.png")
                              as ImageProvider,
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Pengajuan Cuti",
                    style: TextStyle(fontSize: 20, fontFamily: "Poppins_Bold"),
                  ),
                ],
              ),
              SizedBox(height: 30),

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
                      backgroundColor: Color(0xFF1485C7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _pickImage,
                    icon: Icon(Icons.photo_library, color: Colors.white),
                    label: Text(
                      "Pilih Gambar",
                      style: TextStyle(color: Colors.white, fontFamily: "Poppins_Regular"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _pickedImage != null
                          ? _pickedImage!.name
                          : "Belum ada gambar",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontFamily: "Poppins_Regular"),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Batal", style: TextStyle(fontFamily: "Poppins_Medium"),),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1485C7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (_buktiBase64 == null) return;

                      final doc = await FirebaseFirestore.instance
                          .collection('karyawan')
                          .doc(widget.idKaryawan)
                          .get();

                      final data = doc.data();
                      int jatahCuti = data?['jatahCuti'] ?? 0;

                      int durasi = hitungDurasi(
                        tglAwalController.text.trim(),
                        tglAkhirController.text.trim(),
                      );

                      if (durasi == 0) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            content: Text("Format tanggal salah / tidak valid", style: TextStyle(fontFamily: "Poppins_Regular"),),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK", style: TextStyle(fontFamily: "Poppins_Regular")),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      if (durasi > jatahCuti) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            content: Text("Jatah cuti anda tidak cukup", style: TextStyle(fontFamily: "Poppins_Regular")),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK", style: TextStyle(fontFamily: "Poppins_Regular")),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      await _cutiService.ajukanCuti(
                        idKaryawan: widget.idKaryawan,
                        nama: namaController.text,
                        jabatan: jabatanController.text,
                        tglAwal: tglAwalController.text,
                        tglAkhir: tglAkhirController.text,
                        alasan: alasanController.text,
                        buktiBase64: _buktiBase64!,
                        durasiCuti: durasi,
                      );

                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: Text("Cuti berhasil ditambahkan!", style: TextStyle(fontFamily: "Poppins_Regular")),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text("OK", style: TextStyle(fontFamily: "Poppins_Regular")),
                            ),
                          ],
                        ),
                      );
                    },

                    child: Text(
                      "Ajukan",
                      style: TextStyle(color: Colors.white, fontFamily: "Poppins_Medium"),
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
    padding: EdgeInsets.only(top: 12, bottom: 6),
    child: Text(t, style: TextStyle(fontFamily: "Poppins_SemiBold")),
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
        fillColor: Color(0xFFF6F6F6),
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
  RiwayatCutiPage({super.key, required this.idKaryawan});

  final FirestoreServiceCuti _cutiService = FirestoreServiceCuti();

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
        decoration: BoxDecoration(
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
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Riwayat Cuti",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: "Poppins_Bold"
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _cutiService.getRiwayatCutiByKaryawan(idKaryawan),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text("Terjadi kesalahan"));
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text("Belum ada riwayat cuti"));
                        }

                        return ListView(
                          padding: EdgeInsets.all(16),
                          children: snapshot.data!.docs.map((doc) {
                            final d = doc.data() as Map<String, dynamic>;

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  d['alasan'],
                                  style: TextStyle(fontFamily: "Poppins_Medium"),
                                ),
                                subtitle: Text(
                                  "${d['tgl_awal']} - ${d['tgl_akhir']}", style: TextStyle(fontFamily: "Poppins_Regular"),
                                ),
                                trailing: Text(
                                  d['status'],
                                  style: TextStyle(
                                    color: _statusColor(d['status']),
                                    fontFamily: "Poppins_Bold",
                                    fontSize: 12
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
        backgroundColor: Color(0xFF1485C7),
        child: Icon(Icons.add, color: Colors.white),
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
