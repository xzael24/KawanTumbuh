import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_assets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PUBLIC API — satu panggilan dari mana saja:
//   ChatbotOverlay.show(context);
// ─────────────────────────────────────────────────────────────────────────────
class ChatbotOverlay {
  static OverlayEntry? _entry;

  static void show(BuildContext context) {
    if (_entry != null) return; // sudah terbuka
    HapticFeedback.lightImpact();

    _entry = OverlayEntry(
      builder: (_) => _ChatbotSheet(onClose: _close),
    );
    Overlay.of(context).insert(_entry!);
  }

  static void _close() {
    _entry?.remove();
    _entry = null;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHEET — slide-up panel penuh layar dengan animasi masuk Sprout
// ─────────────────────────────────────────────────────────────────────────────
class _ChatbotSheet extends StatefulWidget {
  final VoidCallback onClose;
  const _ChatbotSheet({required this.onClose});

  @override
  State<_ChatbotSheet> createState() => _ChatbotSheetState();
}

class _ChatbotSheetState extends State<_ChatbotSheet>
    with TickerProviderStateMixin {
  // ── Animasi panel slide-up ───────────────────────────────────────────
  late final AnimationController _sheetCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  // ── Animasi Sprout masuk (bounce dari bawah) ─────────────────────────
  late final AnimationController _sproutCtrl;
  late final Animation<double> _sproutScale;
  late final Animation<Offset> _sproutSlide;

  // ── Animasi kedip "online" dot ───────────────────────────────────────
  late final AnimationController _dotCtrl;

  // ── Chat state ───────────────────────────────────────────────────────
  final TextEditingController _textCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final List<_Msg> _msgs = [];
  bool _isTyping = false;
  bool _welcomeShown = false;

  // ── Warna ────────────────────────────────────────────────────────────
  static const Color _teal = Color(0xFF5F8F8A);
  static const Color _tealLight = Color(0xFFE8F2F1);
  static const Color _bg = Color(0xFFF5F0E8);
  static const Color _dark = Color(0xFF1A1A1A);
  static const Color _muted = Color(0xFF7A7A7A);

  // ── Quick replies ────────────────────────────────────────────────────
  static const _quickReplies = [
    '🌱 Apa itu Disleksia?',
    '🔢 Apa itu Diskalkulia?',
    '✏️ Apa itu Disgrafia?',
    '📋 Cara mulai skrining',
    '🎯 Tips belajar anak',
  ];

  static const _answers = {
    '🌱 Apa itu Disleksia?':
        'Disleksia adalah kesulitan membaca yang memengaruhi kemampuan anak mengenali kata dan ejaan, meskipun kecerdasannya normal. Anak dengan disleksia bisa belajar dengan cara yang tepat! 📚',
    '🔢 Apa itu Diskalkulia?':
        'Diskalkulia adalah kesulitan memahami angka dan operasi matematika. Bukan karena anak malas — otaknya butuh pendekatan belajar yang berbeda. Kita bisa bantu! 🔢',
    '✏️ Apa itu Disgrafia?':
        'Disgrafia adalah kesulitan menulis tangan — hurufnya tidak rapi atau sulit mengekspresikan pikiran lewat tulisan. Dengan latihan dan dukungan, anak bisa berkembang! ✏️',
    '📋 Cara mulai skrining':
        'Kamu bisa mulai skrining lewat menu "Skrining" di halaman utama. Isi kuesioner singkat dan aku akan bantu analisis hasilnya bersama kamu! 🌟',
    '🎯 Tips belajar anak':
        'Tips ampuh: gunakan warna-warni saat belajar, bagi materi jadi bagian kecil, beri pujian setiap kemajuan kecil, dan istirahat teratur. Semangat! 💪',
  };

  @override
  void initState() {
    super.initState();

    // Panel slide-up
    _sheetCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _slideAnim = Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _sheetCtrl, curve: Curves.easeOutCubic),
    );
    _fadeAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _sheetCtrl, curve: const Interval(0, 0.4, curve: Curves.easeIn)),
    );

    // Sprout bounce masuk (delay 300ms setelah panel muncul)
    _sproutCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _sproutScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 55),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.9), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.05), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 10),
    ]).animate(CurvedAnimation(parent: _sproutCtrl, curve: Curves.easeOut));
    _sproutSlide =
        Tween(begin: const Offset(0, 0.6), end: Offset.zero).animate(
      CurvedAnimation(parent: _sproutCtrl, curve: Curves.easeOutBack),
    );

    // Dot blink
    _dotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Mulai animasi
    _sheetCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _sproutCtrl.forward();
    });

    // Pesan selamat datang
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted && !_welcomeShown) {
        _welcomeShown = true;
        setState(() => _isTyping = true);
      }
    });
    Future.delayed(const Duration(milliseconds: 1900), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _msgs.add(_Msg(
            text:
                'Halo! 👋 Aku Sprout, teman belajarmu di KawanTumbuh!\n\nAku siap bantu kamu memahami tentang Disleksia, Disgrafia, dan Diskalkulia. Mau tanya apa hari ini? 🌱',
            isUser: false,
          ));
        });
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    _sheetCtrl.dispose();
    _sproutCtrl.dispose();
    _dotCtrl.dispose();
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── Tutup dengan animasi slide-down ──────────────────────────────────
  Future<void> _dismiss() async {
    _focusNode.unfocus();
    await _sheetCtrl.reverse();
    widget.onClose();
  }

  // ── Kirim pesan ──────────────────────────────────────────────────────
  void _send(String text) {
    final t = text.trim();
    if (t.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() {
      _msgs.add(_Msg(text: t, isUser: true));
      _textCtrl.clear();
      _isTyping = true;
    });
    _scrollToBottom();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final answer = _answers[t] ??
          'Wah, pertanyaan bagus! 🌟 Untuk saat ini aku masih belajar menjawab itu. Coba tanya yang lain atau pilih dari saran di bawah ya!';
      setState(() {
        _isTyping = false;
        _msgs.add(_Msg(text: answer, isUser: false));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 80), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // ── Backdrop semi-transparan ──────────────────────────────
          FadeTransition(
            opacity: _fadeAnim,
            child: GestureDetector(
              onTap: _dismiss,
              child: Container(color: Colors.black.withValues(alpha: 0.45)),
            ),
          ),

          // ── Panel chatbot ─────────────────────────────────────────
          SlideTransition(
            position: _slideAnim,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: mq.size.height * 0.88,
                decoration: const BoxDecoration(
                  color: _bg,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  children: [
                    _buildHandle(),
                    _buildHeader(mq),
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),
                    Expanded(child: _buildMessages()),
                    _buildQuickReplies(),
                    _buildInput(mq),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Handle drag-pill ─────────────────────────────────────────────────
  Widget _buildHandle() {
    return GestureDetector(
      onVerticalDragEnd: (d) {
        if ((d.primaryVelocity ?? 0) > 300) _dismiss();
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(top: 10, bottom: 4),
        child: Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFCCCCCC),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  // ── Header: avatar Sprout besar dengan animasi bounce ────────────────
  Widget _buildHeader(MediaQueryData mq) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      color: _bg,
      child: Row(
        children: [
          // Avatar Sprout — animasi bounce masuk
          SlideTransition(
            position: _sproutSlide,
            child: ScaleTransition(
              scale: _sproutScale,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _teal.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    AppAssets.maskotSprout,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, e, st) => const Icon(
                      Icons.eco_rounded,
                      color: _teal,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sprout',
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _dark,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    // Dot online berkedip
                    AnimatedBuilder(
                      animation: _dotCtrl,
                      builder: (ctx, _) => Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: Color.lerp(
                            const Color(0xFF4CAF50),
                            const Color(0xFF81C784),
                            _dotCtrl.value,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Siap membantu kamu!',
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tombol tutup
          GestureDetector(
            onTap: _dismiss,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.close_rounded,
                  size: 20, color: Color(0xFF555555)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Daftar pesan ─────────────────────────────────────────────────────
  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: _msgs.length + (_isTyping ? 1 : 0),
      itemBuilder: (ctx, i) {
        if (i == _msgs.length) return _buildTypingBubble();
        return _buildBubble(_msgs[i], i);
      },
    );
  }

  Widget _buildBubble(_Msg msg, int index) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(index),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      builder: (_, v, child) =>
          Transform.scale(scale: v, alignment: msg.isUser
              ? Alignment.centerRight
              : Alignment.centerLeft, child: child),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment:
              msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!msg.isUser) _sproutMini(),
            if (!msg.isUser) const SizedBox(width: 7),
            Flexible(
              child: Column(
                crossAxisAlignment: msg.isUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                        maxWidth:
                            MediaQuery.of(context).size.width * 0.72),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: msg.isUser ? _teal : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft:
                            Radius.circular(msg.isUser ? 18 : 4),
                        bottomRight:
                            Radius.circular(msg.isUser ? 4 : 18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: msg.isUser
                          ? null
                          : Border.all(
                              color: _teal.withValues(alpha: 0.18),
                            ),
                    ),
                    child: Text(
                      msg.text,
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: msg.isUser ? Colors.white : _dark,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _fmt(msg.time),
                    style: GoogleFonts.quicksand(
                        fontSize: 10, color: _muted),
                  ),
                ],
              ),
            ),
            if (msg.isUser) const SizedBox(width: 7),
            if (msg.isUser) _userMini(),
          ],
        ),
      ),
    );
  }

  Widget _sproutMini() => Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
            color: Colors.white, shape: BoxShape.circle),
        child: ClipOval(
          child: Image.asset(AppAssets.maskotSprout,
              fit: BoxFit.contain,
              errorBuilder: (ctx, e, st) =>
                  const Icon(Icons.eco_rounded, color: _teal, size: 16)),
        ),
      );

  Widget _userMini() => Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            color: _teal.withValues(alpha: 0.15),
            shape: BoxShape.circle),
        child: const Icon(Icons.person_rounded, color: _teal, size: 17),
      );

  Widget _buildTypingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _sproutMini(),
          const SizedBox(width: 7),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(color: _teal.withValues(alpha: 0.18)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: const _BouncingDots(),
          ),
        ],
      ),
    );
  }

  // ── Quick replies ────────────────────────────────────────────────────
  Widget _buildQuickReplies() {
    return Container(
      color: _bg,
      padding: const EdgeInsets.fromLTRB(16, 6, 0, 6),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _quickReplies.length,
          separatorBuilder: (_, i) => const SizedBox(width: 8),
          itemBuilder: (ctx, i) => GestureDetector(
            onTap: () => _send(_quickReplies[i]),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: _teal.withValues(alpha: 0.5), width: 1.2),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1)),
                ],
              ),
              child: Text(
                _quickReplies[i],
                style: GoogleFonts.quicksand(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _teal),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Input bar ────────────────────────────────────────────────────────
  Widget _buildInput(MediaQueryData mq) {
    final bottom = mq.viewInsets.bottom > 0 ? 10.0 : mq.padding.bottom + 12;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -3)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: _tealLight,
                  borderRadius: BorderRadius.circular(24)),
              child: TextField(
                controller: _textCtrl,
                focusNode: _focusNode,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _dark),
                decoration: InputDecoration(
                  hintText: 'Tanya Sprout sesuatu...',
                  hintStyle: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _muted),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                ),
                onSubmitted: _send,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _send(_textCtrl.text),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _teal,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: _teal.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Model pesan
// ─────────────────────────────────────────────────────────────────────────────
class _Msg {
  final String text;
  final bool isUser;
  final DateTime time;
  _Msg({required this.text, required this.isUser}) : time = DateTime.now();
}

// ─────────────────────────────────────────────────────────────────────────────
// Animasi titik-titik mengetik (bounce bergantian)
// ─────────────────────────────────────────────────────────────────────────────
class _BouncingDots extends StatefulWidget {
  const _BouncingDots();

  @override
  State<_BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<_BouncingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final phase =
              ((_ctrl.value * 3) - i).clamp(0.0, 1.0);
          final dy = (phase < 0.5 ? phase : 1.0 - phase) *
              math.pi;
          final offset = math.sin(dy) * 6.0;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Transform.translate(
              offset: Offset(0, -offset),
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF5F8F8A),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CHATBOT BUTTON — FAB reusable, pakai di semua halaman
// Panggil: const ChatbotButton()  — letakkan sebagai floatingActionButton
// ─────────────────────────────────────────────────────────────────────────────
class ChatbotButton extends StatefulWidget {
  const ChatbotButton({super.key});

  @override
  State<ChatbotButton> createState() => _ChatbotButtonState();
}

class _ChatbotButtonState extends State<ChatbotButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wiggleCtrl;
  late final Animation<double> _wiggle;

  @override
  void initState() {
    super.initState();
    // Wiggle kecil tiap 4 detik biar terlihat "hidup"
    _wiggleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _wiggle = Tween(begin: -0.06, end: 0.06).animate(
      CurvedAnimation(parent: _wiggleCtrl, curve: Curves.elasticInOut),
    );

    Future.delayed(const Duration(seconds: 2), _startWiggle);
  }

  void _startWiggle() async {
    while (mounted) {
      await _wiggleCtrl.forward();
      await _wiggleCtrl.reverse();
      await Future.delayed(const Duration(seconds: 4));
    }
  }

  @override
  void dispose() {
    _wiggleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _wiggle,
      builder: (_, child) => Transform.rotate(
        angle: _wiggle.value,
        child: child,
      ),
      child: GestureDetector(
        onTap: () => ChatbotOverlay.show(context),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF5F8F8A),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5F8F8A).withValues(alpha: 0.45),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipOval(
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                AppAssets.maskotSprout,
                fit: BoxFit.contain,
                errorBuilder: (ctx, e, st) => const Icon(
                  Icons.chat_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
