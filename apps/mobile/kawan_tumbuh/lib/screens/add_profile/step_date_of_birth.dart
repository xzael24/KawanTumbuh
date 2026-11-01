import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/step_header.dart';
import '../../widgets/step_title.dart';

class StepDateOfBirth extends StatefulWidget {
  const StepDateOfBirth({
    super.key,
    required this.initialValue,
    required this.step,
    required this.totalSteps,
    required this.onBack,
    required this.onNext,
  });

  final DateTime? initialValue;
  final int step;
  final int totalSteps;
  final VoidCallback onBack;
  final void Function(DateTime dob) onNext;

  @override
  State<StepDateOfBirth> createState() => _StepDateOfBirthState();
}

class _StepDateOfBirthState extends State<StepDateOfBirth> {
  late DateTime _displayMonth;
  DateTime? _selected;

  static const List<String> _dayLabels = [
    'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su',
  ];
  static const List<String> _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayMonth = DateTime(
      widget.initialValue?.year ?? now.year,
      widget.initialValue?.month ?? now.month,
    );
    _selected = widget.initialValue;
  }

  void _prevMonth() => setState(() {
        _displayMonth = DateTime(
          _displayMonth.month == 1 ? _displayMonth.year - 1 : _displayMonth.year,
          _displayMonth.month == 1 ? 12 : _displayMonth.month - 1,
        );
      });

  void _nextMonth() => setState(() {
        _displayMonth = DateTime(
          _displayMonth.month == 12 ? _displayMonth.year + 1 : _displayMonth.year,
          _displayMonth.month == 12 ? 1 : _displayMonth.month + 1,
        );
      });

  void _changeYear(int year) =>
      setState(() => _displayMonth = DateTime(year, _displayMonth.month));

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
          const SizedBox(height: 28),
          _InlineCalendar(
            displayMonth: _displayMonth,
            selected: _selected,
            dayLabels: _dayLabels,
            monthNames: _monthNames,
            onPrevMonth: _prevMonth,
            onNextMonth: _nextMonth,
            onSelectDay: (day) => setState(() => _selected = day),
            onYearChanged: _changeYear,
          ),
          const Spacer(),
          PrimaryButton(
            label: 'Simpan & Lanjut',
            enabled: _selected != null,
            onPressed: () => widget.onNext(_selected!),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Inline Calendar
// ─────────────────────────────────────────────────────────────────────────────
class _InlineCalendar extends StatefulWidget {
  const _InlineCalendar({
    required this.displayMonth,
    required this.selected,
    required this.dayLabels,
    required this.monthNames,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onSelectDay,
    required this.onYearChanged,
  });

  final DateTime displayMonth;
  final DateTime? selected;
  final List<String> dayLabels;
  final List<String> monthNames;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final void Function(DateTime) onSelectDay;
  final void Function(int year) onYearChanged;

  @override
  State<_InlineCalendar> createState() => _InlineCalendarState();
}

class _InlineCalendarState extends State<_InlineCalendar> {
  bool _showYearPicker = false;

  static final int _minYear = 1990;
  static final int _maxYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: 1.2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SELECT DATE OF BIRTH',
            style: AppTextStyles.inter(11, FontWeight.w600, AppColors.textMuted,
                letterSpacing: 0.8),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: () =>
                    setState(() => _showYearPicker = !_showYearPicker),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${widget.monthNames[widget.displayMonth.month - 1]} ${widget.displayMonth.year}',
                      style: AppTextStyles.sora(18, FontWeight.w700, AppColors.pink),
                    ),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: _showYearPicker ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_down,
                          size: 18, color: AppColors.pink),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (!_showYearPicker) ...[
                GestureDetector(
                  onTap: widget.onPrevMonth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: const Icon(Icons.chevron_left,
                        size: 20, color: AppColors.textMuted),
                  ),
                ),
                GestureDetector(
                  onTap: widget.onNextMonth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: const Icon(Icons.chevron_right,
                        size: 20, color: AppColors.textMuted),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _showYearPicker
                ? _YearGrid(
                    key: const ValueKey('year_grid'),
                    currentYear: widget.displayMonth.year,
                    minYear: _minYear,
                    maxYear: _maxYear,
                    onSelectYear: (year) {
                      widget.onYearChanged(year);
                      setState(() => _showYearPicker = false);
                    },
                  )
                : _CalendarGrid(
                    key: const ValueKey('calendar_grid'),
                    displayMonth: widget.displayMonth,
                    selected: widget.selected,
                    dayLabels: widget.dayLabels,
                    onSelectDay: widget.onSelectDay,
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Year Grid
// ─────────────────────────────────────────────────────────────────────────────
class _YearGrid extends StatefulWidget {
  const _YearGrid({
    super.key,
    required this.currentYear,
    required this.minYear,
    required this.maxYear,
    required this.onSelectYear,
  });

  final int currentYear;
  final int minYear;
  final int maxYear;
  final void Function(int year) onSelectYear;

  @override
  State<_YearGrid> createState() => _YearGridState();
}

class _YearGridState extends State<_YearGrid> {
  late final ScrollController _scrollCtrl;

  @override
  void initState() {
    super.initState();
    final years = List.generate(
        widget.maxYear - widget.minYear + 1, (i) => widget.minYear + i);
    final idx = years.indexOf(widget.currentYear);
    final targetRow = (idx / 3).floor();
    final initialOffset = (targetRow * 40.0) - 40.0;
    _scrollCtrl = ScrollController(
      initialScrollOffset: initialOffset.clamp(0.0, double.infinity),
    );
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final years = List.generate(
        widget.maxYear - widget.minYear + 1, (i) => widget.minYear + i);
    return SizedBox(
      height: 200,
      child: GridView.builder(
        controller: _scrollCtrl,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: years.length,
        itemBuilder: (context, index) {
          final year = years[index];
          final isActive = year == widget.currentYear;
          return GestureDetector(
            onTap: () => widget.onSelectYear(year),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: isActive ? AppColors.pink : AppColors.cardCream,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isActive ? AppColors.pinkBorder : Colors.transparent,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '$year',
                style: AppTextStyles.inter(
                  13,
                  isActive ? FontWeight.w700 : FontWeight.w500,
                  isActive ? AppColors.textDark : AppColors.textMuted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Calendar Grid
// ─────────────────────────────────────────────────────────────────────────────
class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    super.key,
    required this.displayMonth,
    required this.selected,
    required this.dayLabels,
    required this.onSelectDay,
  });

  final DateTime displayMonth;
  final DateTime? selected;
  final List<String> dayLabels;
  final void Function(DateTime) onSelectDay;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(displayMonth.year, displayMonth.month, 1);
    final lastDay = DateTime(displayMonth.year, displayMonth.month + 1, 0);
    final startOffset = (firstDay.weekday - 1) % 7;
    final totalCells = startOffset + lastDay.day;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: dayLabels
              .map((d) => SizedBox(
                    width: 32,
                    child: Center(
                      child: Text(
                        d,
                        style: AppTextStyles.inter(
                            12, FontWeight.w600, AppColors.textMuted),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        ...List.generate(rows, (row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (col) {
                final cellIndex = row * 7 + col;
                final dayNum = cellIndex - startOffset + 1;
                final isCurrentMonth = dayNum >= 1 && dayNum <= lastDay.day;
                final date = isCurrentMonth
                    ? DateTime(displayMonth.year, displayMonth.month, dayNum)
                    : null;
                final isSelected = date != null &&
                    selected != null &&
                    date.year == selected!.year &&
                    date.month == selected!.month &&
                    date.day == selected!.day;

                return GestureDetector(
                  onTap: date != null ? () => onSelectDay(date) : null,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.pink : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isCurrentMonth ? '$dayNum' : '',
                      style: AppTextStyles.inter(
                        13,
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                        isSelected
                            ? AppColors.textDark
                            : isCurrentMonth
                                ? AppColors.textDark
                                : const Color(0xFFCCCCCC),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }
}
