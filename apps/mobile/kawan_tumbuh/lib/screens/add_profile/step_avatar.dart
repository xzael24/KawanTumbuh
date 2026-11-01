import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
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
    // TODO: implementasi image_picker saat backend siap
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StepHeader(
            step: widget.step,
            totalSteps: widget.totalSteps,
            onBack: widget.onBack,
          ),
          const SizedBox(height: 36),
          const Center(child: StepTitle()),
          const Spacer(),
          Center(
            child: Column(
              children: [
                Text(
                  'Tambah Foto',
                  style: AppTextStyles.inter(14, FontWeight.w700, AppColors.textDark),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _onPickPhoto,
                  child: Container(
                    width: 130,
                    height: 130,
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
                              const Icon(
                                Icons.camera_alt_outlined,
                                color: AppColors.pink,
                                size: 36,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'ADD PHOTO',
                                style: AppTextStyles.inter(
                                  10,
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
          const Spacer(),
          PrimaryButton(
            label: 'Selesai',
            onPressed: () => widget.onFinish(_photoPath),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
