import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_assets.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive.dart';

// ─── Model data poin grafik ───────────────────────────────────────────────────
class _DataPoin {
  const _DataPoin({required this.tanggal, required this.nilai});
  final String tanggal; // label sumbu X (misal '1 Nov')
  final double nilai; // 0 = Berpotensi Rendah, 1 = Berpotensi, 2 = Normal
}

// ─── Model data kondisi ───────────────────────────────────────────────────────
class _KondisiData {
  const _KondisiData({
    required this.nama,
    required this.statusTerbaru,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.chartColor,
    required this.imagePath,
  });
  final String nama;
  final String statusTerbaru;
  final Color badgeColor;
  final Color badgeTextColor;
  final Color chartColor;
  final String imagePath;
}

// ─── Data statis ──────────────────────────────────────────────────────────────
const _kondisiList = [
  _KondisiData(
    nama: 'Diskalkulia',
    statusTerbaru: 'Berpotensi',
    badgeColor: Color(0xFFFFF3DC),
    badgeTextColor: Color(0xFFD4860A),
    chartColor: Color(0xFFE05A4E),
    imagePath: AppAssets.therapyDyscalculia,
  ),
  _KondisiData(
    nama: 'Diseleksia',
    statusTerbaru: 'Normal',
    badgeColor: Color(0xFFECF5F4),
    badgeTextColor: Color(0xFF4A8C87),
    chartColor: Color(0xFF5F8F8A),
    imagePath: AppAssets.therapyDyslexia,
  ),
  _KondisiData(
    nama: 'Disgrafia',
    statusTerbaru: 'Potensi Rendah',
    badgeColor: Color(0xFFFFF3DC),
    badgeTextColor: Color(0xFFBB8800),
    chartColor: Color(0xFF8DB09D),
    imagePath: AppAssets.therapyDysgraphia,
  ),
];

// Data poin grafik masing-masing kondisi (nilai: 0=BerpotensiRendah, 1=Berpotensi, 2=Normal)
const _dataDiskalkulia = [
  _DataPoin(tanggal: '1 Nov', nilai: 2),
  _DataPoin(tanggal: '6 Nov', nilai: 1),
  _DataPoin(tanggal: '11 Nov', nilai: 2),
  _DataPoin(tanggal: '15 Nov', nilai: 1),
  _DataPoin(tanggal: '18 Nov', nilai: 2),
  _DataPoin(tanggal: '20 Nov', nilai: 2),
  _DataPoin(tanggal: '22 Nov', nilai: 0),
];

const _dataDisleksia = [
  _DataPoin(tanggal: '1 Nov', nilai: 2),
  _DataPoin(tanggal: '6 Nov', nilai: 1),
  _DataPoin(tanggal: '11 Nov', nilai: 2),
  _DataPoin(tanggal: '15 Nov', nilai: 1),
  _DataPoin(tanggal: '18 Nov', nilai: 2),
  _DataPoin(tanggal: '20 Nov', nilai: 2),
  _DataPoin(tanggal: '22 Nov', nilai: 0),
];

const _dataDisgrafia = [
  _DataPoin(tanggal: '1 Nov', nilai: 1),
  _DataPoin(tanggal: '6 Nov', nilai: 0),
  _DataPoin(tanggal: '11 Nov', nilai: 1),
  _DataPoin(tanggal: '15 Nov', nilai: 1),
  _DataPoin(tanggal: '18 Nov', nilai: 1),
  _DataPoin(tanggal: '20 Nov', nilai: 0),
  _DataPoin(tanggal: '22 Nov', nilai: 1),
];

final _chartData = [_dataDiskalkulia, _dataDisleksia, _dataDisgrafia];

// ─── Screen Laporan ───────────────────────────────────────────────────────────
class LaporanScreen extends StatelessWidget {
  const LaporanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: r.w(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: r.h(16)),

              // ── Tombol kembali ────────────────────────────────────
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back,
                        size: r.sp(20), color: AppColors.textDark),
                    SizedBox(width: r.w(6)),
                    Text(
                      'Kembali',
                      style: GoogleFonts.inter(
                        fontSize: r.sp(14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: r.h(12)),

              // ── Judul ────────────────────────────────────────────
              Text(
                'Laporan',
                style: GoogleFonts.inter(
                  fontSize: r.sp(26),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),

              SizedBox(height: r.h(16)),

              // ── Kartu profil anak ────────────────────────────────
              _ProfilAnakCard(r: r),

              SizedBox(height: r.h(24)),

              // ── Bagian Terbaru ───────────────────────────────────
              Text(
                'Terbaru',
                style: GoogleFonts.inter(
                  fontSize: r.sp(16),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: r.h(12)),
              _TerbaruRow(r: r),

              SizedBox(height: r.h(24)),

              // ── Chart per kondisi ─────────────────────────────────
              ...List.generate(_kondisiList.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(bottom: r.h(16)),
                  child: _ChartCard(
                    kondisi: _kondisiList[i],
                    dataPoin: _chartData[i],
                    r: r,
                  ),
                );
              }),

              SizedBox(height: r.h(24)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Kartu profil anak ────────────────────────────────────────────────────────
class _ProfilAnakCard extends StatelessWidget {
  const _ProfilAnakCard({required this.r});
  final Responsive r;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(r.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFCCCAF0),
        borderRadius: BorderRadius.circular(r.r(16)),
      ),
      child: Row(
        children: [
          // Avatar bulat
          Container(
            width: r.w(64),
            height: r.w(64),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFFB0ADE0),
                width: 2,
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.asset(
              AppAssets.avatarGirl,
              fit: BoxFit.cover,
              errorBuilder: (ctx, e, s) => Icon(
                Icons.person,
                size: r.sp(36),
                color: const Color(0xFF9E9EB8),
              ),
            ),
          ),
          SizedBox(width: r.w(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aca Azzahra',
                  style: GoogleFonts.inter(
                    fontSize: r.sp(16),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: r.h(4)),
                Text(
                  'Pantau Hasil Dan Perkembangan Anak',
                  style: GoogleFonts.inter(
                    fontSize: r.sp(12),
                    fontWeight: FontWeight.w400,
                    color: AppColors.textDark.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Baris kartu Terbaru (3 kondisi) ─────────────────────────────────────────
class _TerbaruRow extends StatelessWidget {
  const _TerbaruRow({required this.r});
  final Responsive r;

  @override
  Widget build(BuildContext context) {
    // Warna background kartu Terbaru
    final cardColors = [
      const Color(0xFFF57568), // Diskalkulia — merah
      const Color(0xFF678E8B), // Disleksia  — teal
      const Color(0xFFFFECC1), // Disgrafia  — kuning
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(_kondisiList.length, (i) {
        final k = _kondisiList[i];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: i < _kondisiList.length - 1 ? r.w(10) : 0,
            ),
            child: _TerbaruCard(
              kondisi: k,
              bgColor: cardColors[i],
              r: r,
            ),
          ),
        );
      }),
    );
  }
}

// ─── Kartu kondisi Terbaru ────────────────────────────────────────────────────
class _TerbaruCard extends StatelessWidget {
  const _TerbaruCard({
    required this.kondisi,
    required this.bgColor,
    required this.r,
  });
  final _KondisiData kondisi;
  final Color bgColor;
  final Responsive r;

  @override
  Widget build(BuildContext context) {
    // Teks label status menyesuaikan warna background
    final isDark = bgColor.computeLuminance() < 0.5;
    final namaColor = isDark ? Colors.white : AppColors.textDark;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: r.w(8), vertical: r.h(10)),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(r.r(14)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gambar ilustrasi
          SizedBox(
            height: r.h(70),
            child: Image.asset(
              kondisi.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (ctx, e, s) => Icon(
                Icons.child_care,
                size: r.sp(40),
                color: namaColor.withValues(alpha: 0.6),
              ),
            ),
          ),
          SizedBox(height: r.h(6)),
          // Nama kondisi
          Text(
            kondisi.nama,
            style: GoogleFonts.inter(
              fontSize: r.sp(11),
              fontWeight: FontWeight.w700,
              color: namaColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: r.h(6)),
          // Badge status
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: r.w(8), vertical: r.h(4)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(r.r(20)),
            ),
            child: Text(
              kondisi.statusTerbaru,
              style: GoogleFonts.inter(
                fontSize: r.sp(10),
                fontWeight: FontWeight.w600,
                color: kondisi.badgeTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Kartu grafik garis satu kondisi ─────────────────────────────────────────
class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.kondisi,
    required this.dataPoin,
    required this.r,
  });
  final _KondisiData kondisi;
  final List<_DataPoin> dataPoin;
  final Responsive r;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(r.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.r(16)),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header grafik
          Row(
            children: [
              Icon(
                Icons.show_chart_rounded,
                size: r.sp(18),
                color: AppColors.textDark,
              ),
              SizedBox(width: r.w(8)),
              Text(
                kondisi.nama,
                style: GoogleFonts.inter(
                  fontSize: r.sp(14),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          SizedBox(height: r.h(16)),

          // Grafik garis
          SizedBox(
            height: r.h(140),
            child: _LineChart(
              dataPoin: dataPoin,
              lineColor: kondisi.chartColor,
              r: r,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Custom painter grafik garis ──────────────────────────────────────────────
class _LineChart extends StatelessWidget {
  const _LineChart({
    required this.dataPoin,
    required this.lineColor,
    required this.r,
  });
  final List<_DataPoin> dataPoin;
  final Color lineColor;
  final Responsive r;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _LineChartPainter(
            dataPoin: dataPoin,
            lineColor: lineColor,
          ),
        );
      },
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({required this.dataPoin, required this.lineColor});
  final List<_DataPoin> dataPoin;
  final Color lineColor;

  // Label sumbu Y
  static const _yLabels = ['Normal', 'Berpotensi', 'Berpotensi\nRendah'];
  // nilai 2=Normal (atas), 1=Berpotensi (tengah), 0=BerpotensiRendah (bawah)

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoin.isEmpty) return;

    // Dimensi area plot
    const double leftPad = 72.0; // lebar label Y
    const double rightPad = 10.0;
    const double topPad = 10.0;
    const double bottomPad = 24.0; // untuk label X

    final plotW = size.width - leftPad - rightPad;
    final plotH = size.height - topPad - bottomPad;

    // ── Gambar label sumbu Y ─────────────────────────────────────────
    const yLabelStyle = TextStyle(
      fontSize: 9,
      color: Color(0xFF9E9E9E),
      height: 1.3,
    );
    for (int i = 0; i < _yLabels.length; i++) {
      final yFrac = 1.0 - (i / 2.0); // 2→top, 1→mid, 0→bottom
      final y = topPad + yFrac * plotH;

      final tp = TextPainter(
        text: TextSpan(text: _yLabels[i], style: yLabelStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
      )..layout(maxWidth: leftPad - 8);
      tp.paint(
        canvas,
        Offset(leftPad - tp.width - 8, y - tp.height / 2),
      );

      // Garis bantu horizontal (tipis abu)
      final gridPaint = Paint()
        ..color = const Color(0xFFE8E8E8)
        ..strokeWidth = 0.8;
      canvas.drawLine(
        Offset(leftPad, y),
        Offset(size.width - rightPad, y),
        gridPaint,
      );
    }

    // ── Hitung posisi poin ───────────────────────────────────────────
    final n = dataPoin.length;
    final points = <Offset>[];
    for (int i = 0; i < n; i++) {
      final xFrac = n == 1 ? 0.5 : i / (n - 1).toDouble();
      final yFrac = 1.0 - (dataPoin[i].nilai / 2.0);
      final x = leftPad + xFrac * plotW;
      final y = topPad + yFrac * plotH;
      points.add(Offset(x, y));
    }

    // ── Gambar garis ──────────────────────────────────────────────────
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    // ── Gambar titik poin ─────────────────────────────────────────────
    final dotPaint = Paint()..color = lineColor;
    final dotOutline = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (final p in points) {
      canvas.drawCircle(p, 4.5, dotPaint);
      canvas.drawCircle(p, 4.5, dotOutline);
    }

    // ── Label sumbu X ────────────────────────────────────────────────
    const xLabelStyle = TextStyle(fontSize: 8, color: Color(0xFF9E9E9E));

    // Hanya tampilkan label pertama, tengah-ish, dan terakhir agar tidak penuh
    final showIdx = {0, n ~/ 2, n - 1};
    for (int i = 0; i < n; i++) {
      if (!showIdx.contains(i)) continue;
      final tp = TextPainter(
        text: TextSpan(text: dataPoin[i].tanggal, style: xLabelStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();
      tp.paint(
        canvas,
        Offset(points[i].dx - tp.width / 2,
            size.height - bottomPad + 4),
      );
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter oldDelegate) =>
      oldDelegate.dataPoin != dataPoin ||
      oldDelegate.lineColor != lineColor;
}
