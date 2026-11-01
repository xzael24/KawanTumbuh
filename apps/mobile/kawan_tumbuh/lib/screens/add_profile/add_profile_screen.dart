import 'package:flutter/material.dart';
import 'step_name.dart';
import 'step_gender.dart';
import 'step_date_of_birth.dart';
import 'step_avatar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data sementara yang dikumpulkan selama flow
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileData {
  String name = '';
  String gender = ''; // 'laki-laki' | 'perempuan'
  DateTime? dateOfBirth;
  String? photoPath;
}

// ─────────────────────────────────────────────────────────────────────────────
// Entry point — koordinator 4 langkah
// ─────────────────────────────────────────────────────────────────────────────
class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({super.key});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final _data = _ProfileData();
  int _step = 0; // 0-based (0..3)

  void _nextStep() {
    if (_step < 3) setState(() => _step++);
  }

  void _prevStep() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _finish() {
    // TODO: simpan _data ke state management / backend
    Navigator.of(context).pushReplacementNamed('/loading-profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: _buildStep(),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return StepName(
          key: const ValueKey(0),
          initialValue: _data.name,
          step: _step,
          totalSteps: 4,
          onBack: _prevStep,
          onNext: (name) {
            _data.name = name;
            _nextStep();
          },
        );
      case 1:
        return StepGender(
          key: const ValueKey(1),
          initialValue: _data.gender,
          step: _step,
          totalSteps: 4,
          onBack: _prevStep,
          onNext: (gender) {
            _data.gender = gender;
            _nextStep();
          },
        );
      case 2:
        return StepDateOfBirth(
          key: const ValueKey(2),
          initialValue: _data.dateOfBirth,
          step: _step,
          totalSteps: 4,
          onBack: _prevStep,
          onNext: (dob) {
            _data.dateOfBirth = dob;
            _nextStep();
          },
        );
      case 3:
        return StepAvatar(
          key: const ValueKey(3),
          step: _step,
          totalSteps: 4,
          onBack: _prevStep,
          onFinish: (path) {
            _data.photoPath = path;
            _finish();
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
