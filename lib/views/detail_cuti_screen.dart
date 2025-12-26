import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailCutiScreen extends StatefulWidget {
  final QueryDocumentSnapshot cutiData;

  const DetailCutiScreen({super.key, required this.cutiData});

  @override
  State<DetailCutiScreen> createState() => _DetailCutiScreenState();
}

class _DetailCutiScreenState extends State<DetailCutiScreen> {

  late String status;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    status = widget.cutiData['status'];
  }

  String formatTanggal(dynamic value) {
    if (value is Timestamp) {
      final d = value.toDate();
      return '${d.day.toString().padLeft(2, '0')}/'
          '${d.month.toString().padLeft(2, '0')}/${d.year}';
    }
    if (value is String) return value;
    return '-';
  }

  Uint8List? decodeBase64(String? base64Str) {
    if (base64Str == null || base64Str.isEmpty) return null;
    try {
      return base64Decode(base64Str);
    } catch (_) {
      return null;
    }
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Persetujuan Tidak Valid'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  Future<void> _setujuiCuti() async {
    setState(() => isLoading = true);

    final firestore = FirebaseFirestore.instance;
    final String docId = widget.cutiData.id;
    final String idKaryawan = widget.cutiData['id_karyawan'];
    final int durasiCuti = widget.cutiData['durasi_cuti'];

    final karyawanRef = firestore.collection('karyawan').doc(idKaryawan);
    final cutiRef = firestore.collection('cuti').doc(docId);

    try {
      await firestore.runTransaction((transaction) async {
        final karyawanSnap = await transaction.get(karyawanRef);
        if (!karyawanSnap.exists) {
          throw Exception('Data karyawan tidak ditemukan');
        }

        final data = karyawanSnap.data() as Map<String, dynamic>;
        final int jatahCuti = data['jatahCuti'] ?? 0;

        if (jatahCuti < durasiCuti) {
          throw Exception(
            'Sisa jatah cuti ($jatahCuti hari) lebih kecil dari durasi cuti ($durasiCuti hari)',
          );
        }

        transaction.update(karyawanRef, {
          'jatahCuti': jatahCuti - durasiCuti,
        });

        transaction.update(cutiRef, {
          'status': 'Disetujui',
          'created_at': Timestamp.now(),
        });
      });

      setState(() {
        status = 'Disetujui';
        isLoading = false;
      });

      Navigator.pop(context);
    } catch (e) {
      setState(() => isLoading = false);
      _showAlert(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> _tolakCuti() async {
    setState(() => isLoading = true);

    await FirebaseFirestore.instance
        .collection('cuti')
        .doc(widget.cutiData.id)
        .update({
      'status': 'Ditolak',
      'created_at': Timestamp.now(),
    });

    setState(() {
      status = 'Ditolak';
      isLoading = false;
    });

    Navigator.pop(context);
  }

  void _showFullImage(Uint8List imageBytes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.memory(imageBytes),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.cutiData;
    final imageBytes = decodeBase64(d['bukti_base64']);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Verifikasi Cuti'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('karyawan')
                      .doc(d['id_karyawan'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const CircleAvatar(
                        radius: 36,
                        backgroundImage:
                            AssetImage('assets/images/profile 1.png'),
                      );
                    }

                    final data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    final fotoBytes = decodeBase64(data['foto']);

                    return CircleAvatar(
                      radius: 36,
                      backgroundImage: fotoBytes != null
                          ? MemoryImage(fotoBytes)
                          : const AssetImage('assets/images/profile 1.png')
                              as ImageProvider,
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              _field('ID Karyawan', d['id_karyawan']),
              _field('Nama Lengkap', d['nama']),
              _field('Jabatan', d['jabatan']),

              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('karyawan')
                    .doc(d['id_karyawan'])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return _field('Sisa Jatah Cuti', '...');
                  }

                  final data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return _field(
                    'Sisa Jatah Cuti',
                    '${data['jatahCuti']} hari',
                  );
                },
              ),

              _field('Tanggal Awal Cuti', formatTanggal(d['tgl_awal'])),
              _field('Tanggal Akhir Cuti', formatTanggal(d['tgl_akhir'])),
              _field('Alasan Cuti', d['alasan'], isBox: true),

              const SizedBox(height: 16),
              const Text('Bukti', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              if (imageBytes != null)
                GestureDetector(
                  onTap: () => _showFullImage(imageBytes),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      imageBytes,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                const Text('Tidak ada bukti'),

              const SizedBox(height: 24),

              if (status == 'Dalam Proses')
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _setujuiCuti,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'Setujui',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _tolakCuti,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red),
                        child: const Text(
                          'Tolak',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Center(
                  child: Text(
                    status,
                    style: TextStyle(
                      color:
                          status == 'Disetujui' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _field(String label, String value, {bool isBox = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
