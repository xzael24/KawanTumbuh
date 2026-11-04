import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/responsive.dart';

/// Tombol primer pink yang dipakai di seluruh app.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return SizedBox(
      width: double.infinity,
      height: r.h(52),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pink,
          disabledBackgroundColor: AppColors.pink.withValues(alpha: 0.45),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(r.r(32)),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.inter(
            r.sp(15),
            FontWeight.w600,
            enabled
                ? AppColors.textDark
                : AppColors.textDark.withValues(alpha: 0.45),
          ),
        ),
      ),
    );
  }
}
