import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/step_header.dart';
import '../../widgets/step_title.dart';

class StepGender extends StatefulWidget {
  const StepGender({
    super.key,
    required this.initialValue,
    required this.step,
    required this.totalSteps,
    required this.onBack,
    required this.onNext,
  });

  final String initialValue;
  final int step;
  final int totalSteps;
  final VoidCallback onBack;
  final void Function(String gender) onNext;

  @override
  State<StepGender> createState() => _StepGenderState();
}

class _StepGenderState extends State<StepGender> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
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
          Text('Gender', style: AppTextStyles.labelDark),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GenderCard(
                  label: 'Laki-laki',
                  assetPath: AppAssets.avatarBoy,
                  selected: _selected == 'laki-laki',
                  onTap: () => setState(() => _selected = 'laki-laki'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GenderCard(
                  label: 'Perempuan',
                  assetPath: AppAssets.avatarGirl,
                  selected: _selected == 'perempuan',
                  onTap: () => setState(() => _selected = 'perempuan'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            label: 'Simpan & Lanjut',
            enabled: _selected.isNotEmpty,
            onPressed: () => widget.onNext(_selected),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card pilihan gender
// ─────────────────────────────────────────────────────────────────────────────
class GenderCard extends StatelessWidget {
  const GenderCard({
    super.key,
    required this.label,
    required this.assetPath,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String assetPath;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Border pink peach HANYA melingkari gambar
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? AppColors.pinkBorder : Colors.transparent,
                width: 4,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: AppTextStyles.inter(13, FontWeight.w600, AppColors.textDark),
          ),
        ],
      ),
    );
  }
}
