import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/step_header.dart';
import '../../widgets/step_title.dart';

const _kelasList = [
  'Kelas 1',
  'Kelas 2',
  'Kelas 3',
  'Kelas 4',
  'Kelas 5',
  'Kelas 6',
];

class StepClass extends StatefulWidget {
  const StepClass({
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
  final void Function(String kelas) onNext;

  @override
  State<StepClass> createState() => _StepClassState();
}

class _StepClassState extends State<StepClass> {
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
                Text('Kelas Anak',
                    style: AppTextStyles.inter(
                        r.sp(14), FontWeight.w600, AppColors.textDark)),
                SizedBox(height: r.h(16)),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: r.h(12),
                    crossAxisSpacing: r.w(12),
                    childAspectRatio: (((MediaQuery.of(context).size.width -
                                r.w(48) -
                                r.w(12)) /
                            2) /
                        r.h(52)),
                  ),
                  itemCount: _kelasList.length,
                  itemBuilder: (context, index) {
                    final kelas = _kelasList[index];
                    final isSelected = _selected == kelas;
                    return _ClassCard(
                      label: kelas,
                      selected: isSelected,
                      onTap: () => setState(() => _selected = kelas),
                    );
                  },
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

class _ClassCard extends StatelessWidget {
  const _ClassCard({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.pink : Colors.white,
          borderRadius: BorderRadius.circular(r.r(12)),
          border: Border.all(
            color: selected ? AppColors.pinkBorder : AppColors.border,
            width: selected ? 2 : 1.2,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.inter(
            r.sp(14),
            FontWeight.w600,
            selected ? AppColors.pinkBorder : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
