import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
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
                SizedBox(height: r.h(32)),
                Text('Gender',
                    style: AppTextStyles.inter(
                        r.sp(14), FontWeight.w600, AppColors.textDark)),
                SizedBox(height: r.h(16)),
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
                    SizedBox(width: r.w(16)),
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
                SizedBox(height: r.h(32)),
                PrimaryButton(
                  label: 'Simpan & Lanjut',
                  enabled: _selected.isNotEmpty,
                  onPressed: () => widget.onNext(_selected),
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
    final r = Responsive.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(r.r(14)),
              border: Border.all(
                color: selected ? AppColors.pinkBorder : Colors.transparent,
                width: 4,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(r.r(11)),
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          SizedBox(height: r.h(10)),
          Text(
            label,
            style: AppTextStyles.inter(r.sp(13), FontWeight.w600, AppColors.textDark),
          ),
        ],
      ),
    );
  }
}
