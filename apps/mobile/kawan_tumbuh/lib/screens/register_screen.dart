import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    // TODO: implementasi logika register
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap setujui syarat layanan terlebih dahulu.'),
        ),
      );
      return;
    }
    // Navigasi ke Add Profile setelah register berhasil
    Navigator.of(context).pushReplacementNamed('/add-profile');
  }

  void _onGoogleSignIn() {
    // TODO: implementasi Google Sign In
  }

  void _onFacebookSignIn() {
    // TODO: implementasi Facebook Sign In
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
              // ── Logo ─────────────────────────────────────────────────
              _KawanTumbuhLogo(),

              const SizedBox(height: 32),

              // ── Judul ─────────────────────────────────────────────────
              Text(
                'Daftar',
                style: GoogleFonts.quicksand(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),

              const SizedBox(height: 24),

              // ── Username ──────────────────────────────────────────────
              _FieldLabel(text: 'Username'),
              const SizedBox(height: 6),
              _InputField(
                controller: _usernameController,
                hint: 'Masukan username',
              ),

              const SizedBox(height: 16),

              // ── Email ─────────────────────────────────────────────────
              _FieldLabel(text: 'Email'),
              const SizedBox(height: 6),
              _InputField(
                controller: _emailController,
                hint: 'Masukkan email',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              // ── Password ──────────────────────────────────────────────
              _FieldLabel(text: 'Password'),
              const SizedBox(height: 6),
              _PasswordField(
                controller: _passwordController,
                obscure: _obscurePassword,
                onToggle: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),

              const SizedBox(height: 20),

              // ── Checkbox Syarat ───────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _agreeToTerms,
                      onChanged: (val) {
                        setState(() => _agreeToTerms = val ?? false);
                      },
                      activeColor: const Color(0xFF5F8F8A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'Saya setuju dengan ',
                        style: GoogleFonts.quicksand(
                          fontSize: 13,
                          color: const Color(0xFF4A4A4A),
                        ),
                        children: [
                          TextSpan(
                            text: 'Syarat Layanan, Kebijakan Privasi',
                            style: GoogleFonts.quicksand(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A1A),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ', dan '),
                          TextSpan(
                            text: 'Pengaturan Notifikasi',
                            style: GoogleFonts.quicksand(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A1A),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' default kami'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Tombol Masuk (Register) ───────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5F8F8A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Masuk',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Divider Atau ──────────────────────────────────────────
              _OrDivider(),

              const SizedBox(height: 16),

              // ── Lanjutkan dengan Google ───────────────────────────────
              _SocialButton(
                label: 'Lanjutkan dengan Google',
                onTap: _onGoogleSignIn,
              ),

              const SizedBox(height: 12),

              // ── Lanjutkan dengan Facebook ─────────────────────────────
              _SocialButton(
                label: 'Lanjutkan dengan Facebook',
                onTap: _onFacebookSignIn,
                isFacebook: true,
              ),

              const SizedBox(height: 32),

              // ── Link ke Login ─────────────────────────────────────────
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Sudah punya akun? ',
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: const Color(0xFF4A4A4A),
                    ),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/login');
                          },
                          child: Text(
                            'Masuk',
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
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget: Logo KawanTumbuh
// ─────────────────────────────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────────────────────
// Widget: Label field
// ─────────────────────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.quicksand(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1A1A),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget: Input field biasa
// ─────────────────────────────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const _InputField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.quicksand(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.quicksand(
          fontSize: 14,
          color: const Color(0xFFBBBBBB),
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

// ─────────────────────────────────────────────────────────────────────────────
// Widget: Input field password (dengan toggle)
// ─────────────────────────────────────────────────────────────────────────────
class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.controller,
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
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: const Color(0xFF888888),
            size: 22,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget: Divider "Atau"
// ─────────────────────────────────────────────────────────────────────────────
class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFDDDDDD))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Atau',
            style: GoogleFonts.quicksand(
              fontSize: 13,
              color: const Color(0xFF888888),
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFDDDDDD))),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget: Tombol Social (Google / Facebook)
// ─────────────────────────────────────────────────────────────────────────────
class _SocialButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isFacebook;

  const _SocialButton({
    required this.label,
    required this.onTap,
    this.isFacebook = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFDDDDDD)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isFacebook
                ? Image.asset(
                    'assets/images/facebook_color.png',
                    width: 22,
                    height: 22,
                  )
                : _GoogleIcon(),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Google icon dari asset PNG
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/google_color.png',
      width: 22,
      height: 22,
    );
  }
}
