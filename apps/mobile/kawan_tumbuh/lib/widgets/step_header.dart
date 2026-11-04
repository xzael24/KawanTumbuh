import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive.dart';

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
    final r = Responsive.of(context);
    final progress = (step + 1) / totalSteps;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            width: r.r(36),
            height: r.r(36),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border, width: 1.5),
            ),
            child: Icon(
              Icons.chevron_left_rounded,
              color: AppColors.textDark,
              size: r.r(22),
            ),
          ),
        ),
        SizedBox(height: r.h(14)),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: r.h(5),
            backgroundColor: AppColors.progressBg,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.pink),
          ),
        ),
      ],
    );
  }
}
