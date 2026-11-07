import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

// ─────────────────────────────────────────────────────────────
// Camera Capture Screen — Upload dari Galeri
// Pengguna memilih foto tulisan dari galeri HP.
// ─────────────────────────────────────────────────────────────
class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  String? _selectedPath;
  bool _isPicking = false;

  Future<void> _pickFromGallery() async {
    if (_isPicking) return;
    setState(() => _isPicking = true);

    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 95,
      );

      if (!mounted) return;

      if (picked != null) {
        setState(() => _selectedPath = picked.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal membuka galeri, coba lagi.',
              style: GoogleFonts.quicksand(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  void _retake() {
    setState(() => _selectedPath = null);
  }

  void _usePicture() {
    // TODO: ganti ke /dysgraphia-review setelah backend siap
    Navigator.of(context).pushReplacementNamed('/apresiasi-dysgraphia');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _selectedPath == null
              ? _UploadView(
                  key: const ValueKey('upload'),
                  isPicking: _isPicking,
                  onPick: _pickFromGallery,
                )
              : _PreviewView(
                  key: const ValueKey('preview'),
                  imagePath: _selectedPath!,
                  onRetake: _retake,
                  onUse: _usePicture,
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// View: Pilih dari Galeri
// ─────────────────────────────────────────────────────────────
class _UploadView extends StatelessWidget {
  const _UploadView({
    super.key,
    required this.isPicking,
    required this.onPick,
  });

  final bool isPicking;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final double boxWidth = MediaQuery.of(context).size.width - 48;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 48),

          // ── Kotak upload ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: isPicking ? null : onPick,
              child: SizedBox(
                width: boxWidth,
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAE6DF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFCDC8C0),
                        width: 1.5,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F6F0),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.photo_library_outlined,
                            size: 30,
                            color: Color(0xFF5F8F8A),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Pilih foto dari galeri',
                          style: GoogleFonts.quicksand(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF3A3A3A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Tap untuk membuka galeri',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF9A9A9A),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── Kartu ketentuan foto ──────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _KetentuanCard(),
          ),

          const SizedBox(height: 28),

          // ── Tombol Pilih Foto ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isPicking ? null : onPick,
                icon: isPicking
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.photo_library_outlined, size: 20),
                label: Text(
                  isPicking ? 'Membuka galeri...' : 'Pilih Foto dari Galeri',
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5F8F8A),
                  disabledBackgroundColor:
                      const Color(0xFF5F8F8A).withValues(alpha: 0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// View: Preview foto yang dipilih
// ─────────────────────────────────────────────────────────────
class _PreviewView extends StatelessWidget {
  const _PreviewView({
    super.key,
    required this.imagePath,
    required this.onRetake,
    required this.onUse,
  });

  final String imagePath;
  final VoidCallback onRetake;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context) {
    final double boxWidth = MediaQuery.of(context).size.width - 48;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 48),

          // ── Preview foto ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: boxWidth,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                    width: boxWidth,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── Kartu ketentuan foto ──────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _KetentuanCard(),
          ),

          const SizedBox(height: 28),

          // ── Tombol Pilih Ulang + Gunakan Foto ─────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: onRetake,
                      icon: const Icon(Icons.replay_rounded, size: 18),
                      label: Text(
                        'Pilih Ulang',
                        style: GoogleFonts.quicksand(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF5F8F8A),
                        side: const BorderSide(
                            color: Color(0xFF5F8F8A), width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: onUse,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5F8F8A),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Gunakan Foto',
                        style: GoogleFonts.quicksand(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Widget: Kartu ketentuan foto
// ─────────────────────────────────────────────────────────────
class _KetentuanCard extends StatelessWidget {
  final List<_KetentuanItem> _items = const [
    _KetentuanItem(
      icon: Icons.wb_sunny_outlined,
      label: 'Gunakan cahaya / flash yang cukup',
    ),
    _KetentuanItem(
      icon: Icons.edit_outlined,
      label: 'Tulisan menggunakan pulpen hitam yang jelas',
    ),
    _KetentuanItem(
      icon: Icons.crop_free_rounded,
      label: 'Foto seluruh tulisan, tidak terpotong',
    ),
    _KetentuanItem(
      icon: Icons.blur_off_rounded,
      label: 'Pastikan foto tidak buram / blur',
    ),
  ];

  const _KetentuanCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text(
              'Ketentuan Foto',
              style: GoogleFonts.quicksand(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
                letterSpacing: 0.2,
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          ...List.generate(_items.length, (i) {
            final isLast = i == _items.length - 1;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _items[i].icon,
                        size: 18,
                        color: const Color(0xFF5F8F8A),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _items[i].label,
                          style: GoogleFonts.quicksand(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4A4A4A),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFF0F0F0),
                    indent: 46,
                    endIndent: 16,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _KetentuanItem {
  final IconData icon;
  final String label;
  const _KetentuanItem({required this.icon, required this.label});
}
