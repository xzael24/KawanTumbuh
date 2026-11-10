import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Entry point — Step 1: Lupa Password (input email)
// ─────────────────────────────────────────────────────────────────────────────
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onKirim() {
    // TODO: implementasi kirim email reset password ke backend
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan email kamu terlebih dahulu.')),
      );
      return;
    }
    // Navigasi ke Step 2: Verifikasi OTP
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OtpVerificationScreen(email: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Logo ────────────────────────────────────────────────
              _KawanTumbuhLogo(),

              const SizedBox(height: 40),

              // ── Judul & Subjudul ─────────────────────────────────────
              Center(
                child: Text(
                  'Lupa Password',
                  style: GoogleFonts.quicksand(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Masukkan alamat email untuk mereset password',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: const Color(0xFF7A7A7A),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Ilustrasi ────────────────────────────────────────────
              Center(
                child: Image.asset(
                  'assets/images/reset_password_illustration.png',
                  height: 260,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 40),

              // ── Input Email ──────────────────────────────────────────
              _EmailField(controller: _emailController),

              const SizedBox(height: 16),

              // ── Tombol Kirim ─────────────────────────────────────────
              _PrimaryButton(label: 'Kirim', onPressed: _onKirim),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 2: Masukkan Kode Verifikasi (OTP 6 digit)
// ─────────────────────────────────────────────────────────────────────────────
class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const int _otpLength = 6;
  final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_otpLength, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _onVerifikasi() {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length < _otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan kode verifikasi lengkap.')),
      );
      return;
    }
    // TODO: implementasi verifikasi OTP ke backend
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ResetPasswordScreen(),
      ),
    );
  }

  void _onKirimUlang() {
    // TODO: implementasi kirim ulang OTP ke backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kode verifikasi telah dikirim ulang.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Logo ────────────────────────────────────────────────
              _KawanTumbuhLogo(),

              const SizedBox(height: 40),

              // ── Judul ────────────────────────────────────────────────
              Center(
                child: Text(
                  'Masukkan Kode Verifikasi',
                  style: GoogleFonts.quicksand(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ── Subjudul dengan email bold ───────────────────────────
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Kita telah mengirimkan kode ke ',
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: const Color(0xFF7A7A7A),
                    ),
                    children: [
                      TextSpan(
                        text: widget.email,
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              // ── 6 Kotak OTP ──────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  _otpLength,
                  (index) => _OtpBox(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    onChanged: (val) => _onChanged(val, index),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ── Tombol Verifikasi ────────────────────────────────────
              _PrimaryButton(
                label: 'Verifikasi Sekarang',
                onPressed: _onVerifikasi,
              ),

              const SizedBox(height: 16),

              // ── Kirim Ulang ──────────────────────────────────────────
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Belum menerima kode? ',
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: const Color(0xFF4A4A4A),
                    ),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: GestureDetector(
                          onTap: _onKirimUlang,
                          child: Text(
                            'Kirim Ulang',
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF5F8F8A),
                              decoration: TextDecoration.underline,
                              decorationColor: const Color(0xFF5F8F8A),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 3: Reset Password (input password baru)
// ─────────────────────────────────────────────────────────────────────────────
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onKirim() {
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi.')),
      );
      return;
    }
    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak cocok.')),
      );
      return;
    }
    // TODO: implementasi reset password ke backend
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const ResetPasswordSuccessScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Logo ────────────────────────────────────────────────
              _KawanTumbuhLogo(),

              const SizedBox(height: 40),

              // ── Judul & Subjudul ─────────────────────────────────────
              Center(
                child: Text(
                  'Reset Password',
                  style: GoogleFonts.quicksand(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Password harus berbeda dari sebelumnya',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: const Color(0xFF7A7A7A),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Input Password Baru ──────────────────────────────────
              _PasswordFieldWithIcon(
                controller: _passwordController,
                hint: 'Password baru',
                obscure: _obscurePassword,
                onToggle: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),

              const SizedBox(height: 16),

              // ── Input Konfirmasi Password ────────────────────────────
              _PasswordFieldWithIcon(
                controller: _confirmController,
                hint: 'Konfirmasi password baru',
                obscure: _obscureConfirm,
                onToggle: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),

              const SizedBox(height: 40),

              // ── Tombol Kirim ─────────────────────────────────────────
              _PrimaryButton(label: 'Kirim', onPressed: _onKirim),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 4: Reset Password Berhasil
// ─────────────────────────────────────────────────────────────────────────────
class ResetPasswordSuccessScreen extends StatelessWidget {
  const ResetPasswordSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Logo ────────────────────────────────────────────────
              _KawanTumbuhLogo(),

              const SizedBox(height: 40),

              // ── Judul & Subjudul ─────────────────────────────────────
              Center(
                child: Text(
                  'Reset Password',
                  style: GoogleFonts.quicksand(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Yeyy! Password berhasil di reset',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: const Color(0xFF7A7A7A),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Ilustrasi ────────────────────────────────────────────
              Center(
                child: Image.asset(
                  'assets/images/reset_password_illustration.png',
                  height: 280,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 40),

              // ── Tombol Kembali ke Login ──────────────────────────────
              _PrimaryButton(
                label: 'Kembali ke Login',
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared Widgets
// ─────────────────────────────────────────────────────────────────────────────

// Logo KawanTumbuh
class _KawanTumbuhLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/logo_kawantumbuh.png',
          height: 36,
          errorBuilder: (ctx, err, stack) => const Icon(
            Icons.eco,
            color: Color(0xFF5F8F8A),
            size: 36,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'KawanTumbuh',
          style: GoogleFonts.quicksand(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF5F8F8A),
          ),
        ),
      ],
    );
  }
}

// Input Email dengan icon amplop
class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.quicksand(fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Masukkan email kamu',
        hintStyle: GoogleFonts.quicksand(
          fontSize: 14,
          color: const Color(0xFFBBBBBB),
        ),
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: Color(0xFFBBBBBB),
          size: 20,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF5F8F8A), width: 1.5),
        ),
      ),
    );
  }
}

// Kotak OTP satu digit
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 56,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: GoogleFonts.quicksand(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A1A),
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFF5F8F8A), width: 1.5),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

// Password field dengan icon kunci di kiri
class _PasswordFieldWithIcon extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;

  const _PasswordFieldWithIcon({
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.quicksand(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.quicksand(
          fontSize: 14,
          color: const Color(0xFFBBBBBB),
        ),
        prefixIcon: const Icon(
          Icons.key_outlined,
          color: Color(0xFFBBBBBB),
          size: 20,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xFF888888),
            size: 22,
          ),
          onPressed: onToggle,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF5F8F8A), width: 1.5),
        ),
      ),
    );
  }
}

// Tombol utama hijau
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5F8F8A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
