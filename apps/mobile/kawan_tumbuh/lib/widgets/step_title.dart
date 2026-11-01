import 'package:flutter/material.dart';
import '../core/theme/app_text_styles.dart';

/// Blok judul + sub-judul shared untuk semua step Add Profile.
class StepTitle extends StatelessWidget {
  const StepTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Mari kenali anak\nlebih dekat',
          textAlign: TextAlign.center,
          style: AppTextStyles.headingLarge,
        ),
        const SizedBox(height: 10),
        Text(
          'Kenali kebutuhan dan keunikan anak dengan\nmelengkapi profilnya sebagai langkah awal',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMuted,
        ),
      ],
    );
  }
}
