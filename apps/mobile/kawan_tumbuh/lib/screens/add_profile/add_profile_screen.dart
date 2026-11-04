import 'package:flutter/material.dart';
import 'step_name.dart';
import 'step_gender.dart';
import 'step_class.dart';
import 'step_date_of_birth.dart';
import 'step_avatar.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data sementara yang dikumpulkan selama flow
// ─────────────────────────────────────────────────────────────────────────────
class _ProfileData {
  String name = '';
  String gender = ''; // 'laki-laki' | 'perempuan'
  String kelas = ''; // 'Kelas 1' .. 'Kelas 6'
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
    if (_step < 4) setState(() => _step++);
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

  Widget _buildCurrentStep() {
    switch (_step) {
      case 0:
        return StepName(
          initialValue: _data.name,
          step: 0,
          totalSteps: 5,
          onBack: _prevStep,
          onNext: (name) { _data.name = name; _nextStep(); },
        );
      case 1:
        return StepGender(
          initialValue: _data.gender,
          step: 1,
          totalSteps: 5,
          onBack: _prevStep,
          onNext: (gender) { _data.gender = gender; _nextStep(); },
        );
      case 2:
        return StepClass(
          initialValue: _data.kelas,
          step: 2,
          totalSteps: 5,
          onBack: _prevStep,
          onNext: (kelas) { _data.kelas = kelas; _nextStep(); },
        );
      case 3:
        return StepDateOfBirth(
          initialValue: _data.dateOfBirth,
          step: 3,
          totalSteps: 5,
          onBack: _prevStep,
          onNext: (dob) { _data.dateOfBirth = dob; _nextStep(); },
        );
      case 4:
        return StepAvatar(
          step: 4,
          totalSteps: 5,
          onBack: _prevStep,
          onFinish: (path) { _data.photoPath = path; _finish(); },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: KeyedSubtree(
            key: ValueKey(_step),
            child: _buildCurrentStep(),
          ),
        ),
      ),
    );
  }

}
