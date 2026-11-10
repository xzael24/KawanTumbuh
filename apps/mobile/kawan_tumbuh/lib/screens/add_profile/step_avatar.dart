import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/step_header.dart';
import '../../widgets/step_title.dart';

class StepAvatar extends StatefulWidget {
  const StepAvatar({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.onBack,
    required this.onFinish,
  });

  final int step;
  final int totalSteps;
  final VoidCallback onBack;
  final void Function(String? photoPath) onFinish;

  @override
  State<StepAvatar> createState() => _StepAvatarState();
}

class _StepAvatarState extends State<StepAvatar> {
  String? _photoPath;

  void _onPickPhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Fitur kamera/galeri akan segera tersedia.',
          style: AppTextStyles.inter(13, FontWeight.w400, Colors.white),
        ),
        backgroundColor: const Color(0xFFE88B8B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: r.w(24), vertical: r.h(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StepHeader(
                  step: widget.step,
                  totalSteps: widget.totalSteps,
                  onBack: widget.onBack,
                ),
                SizedBox(height: r.h(36)),
                const Center(child: StepTitle()),
                SizedBox(height: r.h(40)),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Tambah Foto',
                        style: AppTextStyles.inter(
                            r.sp(14), FontWeight.w700, AppColors.textDark),
                      ),
                      SizedBox(height: r.h(16)),
                      GestureDetector(
                        onTap: _onPickPhoto,
                        child: Container(
                          width: r.r(130),
                          height: r.r(130),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: AppColors.pink, width: 2),
                          ),
                          child: _photoPath != null
                              ? ClipOval(
                                  child: Image.asset(
                                    _photoPath!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: AppColors.pink,
                                      size: r.r(36),
                                    ),
                                    SizedBox(height: r.h(6)),
                                    Text(
                                      'ADD PHOTO',
                                      style: AppTextStyles.inter(
                                        r.sp(10),
                                        FontWeight.w700,
                                        AppColors.pink,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: r.h(40)),
                PrimaryButton(
                  label: 'Selesai',
                  onPressed: () => widget.onFinish(_photoPath),
                ),
                SizedBox(height: r.h(32)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
