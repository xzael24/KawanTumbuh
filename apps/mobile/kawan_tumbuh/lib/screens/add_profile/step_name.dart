import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/step_header.dart';
import '../../widgets/step_title.dart';

class StepName extends StatefulWidget {
  const StepName({
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
  final void Function(String name) onNext;

  @override
  State<StepName> createState() => _StepNameState();
}

class _StepNameState extends State<StepName> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                Text('Nama Anak',
                    style: AppTextStyles.inter(
                        r.sp(14), FontWeight.w600, AppColors.textDark)),
                SizedBox(height: r.h(8)),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _ctrl,
                  builder: (context, value, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _ctrl,
                          textCapitalization: TextCapitalization.words,
                          style: AppTextStyles.inter(
                              r.sp(14), FontWeight.w400, AppColors.textDark),
                          decoration: InputDecoration(
                            hintStyle: AppTextStyles.inter(r.sp(14),
                                FontWeight.w400, const Color(0xFFBBBBBB)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: r.w(16), vertical: r.h(14)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(r.r(10)),
                              borderSide: const BorderSide(
                                  color: AppColors.border, width: 1.2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(r.r(10)),
                              borderSide: const BorderSide(
                                  color: AppColors.pink, width: 1.6),
                            ),
                          ),
                        ),
                        SizedBox(height: r.h(24)),
                        PrimaryButton(
                          label: 'Simpan & Lanjut',
                          enabled: value.text.trim().isNotEmpty,
                          onPressed: () => widget.onNext(_ctrl.text.trim()),
                        ),
                      ],
                    );
                  },
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
