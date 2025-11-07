import 'package:myberikan/models/cuti_model.dart';
import 'package:myberikan/models/riwayat_model.dart';
import 'package:myberikan/models/user_model.dart';

final dummyRiwayatCuti = [
  RiwayatCutiModel(
    user: UserModel(
      id: 'NK0139431',
      username: 'pratama',
      password: '12345',
      nama: 'Pratama Pangestu',
      jabatan: 'HR',
      kontrak: 'Tetap',
      jatahCuti: 12,
      absensi: [],
      cuti: [
        CutiModel(
          tanggalMulai: DateTime(2025, 01, 05),
          tanggalAkhir: DateTime(2025, 01, 07),
          alasan: 'Acara keluarga',
          bukti: 'assets/images/bukti1.png',
          status: 'Disetujui',
        ),
        CutiModel(
          tanggalMulai: DateTime(2025, 01, 08),
          tanggalAkhir: DateTime(2025, 01, 09),
          alasan: 'Kepentingan pribadi',
          bukti: 'assets/images/bukti2.png',
          status: 'Dipending',
        ),
      ],
    ),
    daftarCuti: [], // bisa diisi semua cuti dari seluruh user nanti
  ),
];
