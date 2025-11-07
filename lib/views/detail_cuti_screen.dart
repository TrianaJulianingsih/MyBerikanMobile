import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/cuti_model.dart';

class DetailCutiScreen extends StatefulWidget {
  final UserModel user;
  final CutiModel cuti;
  const DetailCutiScreen({super.key, required this.user, required this.cuti});

  @override
  State<DetailCutiScreen> createState() => _DetailCutiScreenState();
}

class _DetailCutiScreenState extends State<DetailCutiScreen> {
  late CutiModel cuti;

  @override
  void initState() {
    super.initState();
    cuti = widget.cuti;
  }

  String formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  }

  void _changeStatus(String status) {
    setState(() {
      cuti.status = status;
    });

    final snackBar = SnackBar(
      content: Text(
        status == 'Disetujui'
            ? 'Pengajuan cuti ${widget.user.nama} telah disetujui'
            : 'Pengajuan cuti ${widget.user.nama} telah ditolak',
      ),
      backgroundColor: status == 'Disetujui' ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Verifikasi Cuti', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 38,
              backgroundImage: AssetImage(
                widget.user.nama.contains('Intan') || widget.user.nama.contains('Nur')
                    ? 'assets/images/image 2.png'
                    : 'assets/images/profile 1.png',
              ),
            ),
          ),
          const SizedBox(height: 25),
          _infoText('ID Karyawan', widget.user.id),
          _infoText('Nama Lengkap', widget.user.nama),
          _infoText('Jabatan', widget.user.jabatan),
          _infoText('Tanggal Awal Cuti', formatDate(cuti.tanggalMulai)),
          _infoText('Tanggal Akhir Cuti', formatDate(cuti.tanggalAkhir)),
          _infoText('Alasan Cuti', cuti.alasan, isMultiline: true),

          const SizedBox(height: 12),
          const Text('Bukti Cuti', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/buktip.jpg',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                      SizedBox(height: 6),
                      Text('Bukti tidak tersedia', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 18),

          if (cuti.status == 'Dipending')
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _changeStatus('Disetujui'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F80ED),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Setujui',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _changeStatus('Ditolak'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 195, 14, 14),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Tolak',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  cuti.status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: cuti.status == 'Disetujui' ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoText(String label, String value, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
            maxLines: isMultiline ? null : 1,
          ),
          const Divider(thickness: 0.5),
        ],
      ),
    );
  }
}
