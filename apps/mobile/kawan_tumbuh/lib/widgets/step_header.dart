import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Header shared untuk setiap step di Add Profile flow:
/// back button bulat + progress bar.
class StepHeader extends StatelessWidget {
  const StepHeader({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.onBack,
  });

  final int step;
  final int totalSteps;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final progress = (step + 1) / totalSteps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 1.5),
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: AppColors.textDark,
              size: 22,
            ),
          ),
        ),
        const SizedBox(height: 14),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor: AppColors.progressBg,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.pink),
          ),
        ),
      ],
    );
  }
}
