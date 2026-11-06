import 'package:flutter/material.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/responsive.dart';

/// Blok judul + sub-judul shared untuk semua step Add Profile.
class StepTitle extends StatelessWidget {
  const StepTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Column(
      children: [
        Text(
          'Mari kenali anak\nlebih dekat',
          textAlign: TextAlign.center,
          style: AppTextStyles.sora(r.sp(22), FontWeight.w700,
              const Color(0xFF1A1A1A), height: 1.35),
        ),
        SizedBox(height: r.h(10)),
        Text(
          'Kenali kebutuhan dan keunikan anak dengan\nmelengkapi profilnya sebagai langkah awal',
          textAlign: TextAlign.center,
          style: AppTextStyles.inter(r.sp(12), FontWeight.w400,
              const Color(0xFF7A7A7A), height: 1.6),
        ),
      ],
    );
  }
}
