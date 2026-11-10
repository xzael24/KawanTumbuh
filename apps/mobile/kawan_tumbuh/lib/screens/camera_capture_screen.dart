import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

// ─────────────────────────────────────────────────────────────
// Camera Capture Screen — Upload Dari Kamera Atau Galeri
// Pengguna memilih foto tulisan dari galeri HP atau buka kamera.
// ─────────────────────────────────────────────────────────────
class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  String? _selectedPath;
  bool _isPicking = false;
  bool _isUsingCamera = true; // ← default pakai kamera

  // Fungsi toggle source (dikelola di parent state)
  void _toggleSource() {
    setState(() {
      _isUsingCamera = !_isUsingCamera;
    });
  }

  Future<void> _pickFromCamera() async {
    if (_isPicking) return;
    setState(() => _isPicking = true);

    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 95,
      );

      if (!mounted) return;

      if (picked != null) {
        setState(() => _selectedPath = picked.path);
      }
    } catch (e) {
      // Jika user deny ijin kamera, fallback ke gallery
      if (!mounted) return;
      if (e.toString().toLowerCase().contains('camera') ||
          e.toString().toLowerCase().contains('permission')) {
        // Tampil pesan singkat lalu pakai gallery
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Kamera tidak diizinkan, menggunakan galeri.',
              style: GoogleFonts.quicksand(color: Colors.white),
            ),
            backgroundColor: Colors.orangeAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
        // Auto fallback ke gallery
        _toggleSource();
        await _pickFromGallery();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal membuka kamera, coba lagi: $e',
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
                  key: ValueKey('upload'),
                  isPicking: _isPicking,
                  isUsingCamera: _isUsingCamera,
                  onPickCamera: _pickFromCamera,
                  onPickGallery: _pickFromGallery,
                  onToggleSource: _toggleSource,
                )
              : _PreviewView(
                  key: ValueKey('preview'),
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
// View: Atau Camera, Atau Galeri
// ─────────────────────────────────────────────────────────────
class _UploadView extends StatelessWidget {
  const _UploadView({
    super.key,
    required this.isPicking,
    required this.isUsingCamera,
    required this.onPickCamera,
    required this.onPickGallery,
    required this.onToggleSource,
  });

  final bool isPicking;
  final bool isUsingCamera;
  final VoidCallback onPickCamera;
  final VoidCallback onPickGallery;
  final VoidCallback onToggleSource;

  @override
  Widget build(BuildContext context) {
    final double boxWidth = MediaQuery.of(context).size.width - 48;
    String toggleLabel() => isUsingCamera ? 'Kamera' : 'Galeri';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),

          // ── Toggle Kamera / Galeri ───────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFEAE6DF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _SourceButton(
                      label: 'Kamera',
                      icon: Icons.camera_alt_outlined,
                      selected: isUsingCamera,
                      onTap: isPicking || isUsingCamera ? null : onToggleSource,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _SourceButton(
                      label: 'Galeri',
                      icon: Icons.photo_library_outlined,
                      selected: !isUsingCamera,
                      onTap: isPicking || !isUsingCamera ? null : onToggleSource,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Kotak upload ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: isPicking
                  ? null
                  : isUsingCamera
                      ? onPickCamera
                      : onPickGallery,
              child: Container(
                width: boxWidth,
                height: boxWidth * 3 / 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAE6DF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isUsingCamera
                          ? Icons.camera_alt_outlined
                          : Icons.photo_library_outlined,
                      size: 64,
                      color: Color(0xFF5F8F8A),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pilih foto dari ${toggleLabel()}',
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF3A3A3A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isUsingCamera
                          ? 'Tap untuk membuka kamera'
                          : 'Tap untuk membuka galeri',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9A9A9A),
                        height: 1.5,
                      ),
                    ),
                  ],
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
                onPressed: isPicking
                    ? null
                    : isUsingCamera
                        ? onPickCamera
                        : onPickGallery,
                icon: isPicking
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Icon(
                        isUsingCamera
                            ? Icons.camera_alt_outlined
                            : Icons.photo_library_outlined,
                        size: 28),
                label: Text(
                  isPicking
                      ? 'Membuka galeri...'
                      : isUsingCamera
                          ? 'Pilih dari Kamera'
                          : 'Pilih dari Galeri',
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

class _SourceButton extends StatelessWidget {
  const _SourceButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 44,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF5F8F8A) : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? Colors.white : const Color(0xFF5F8F8A),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : const Color(0xFF5F8F8A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KetentuanItem {
  final IconData icon;
  final String label;
  const _KetentuanItem({required this.icon, required this.label});
}