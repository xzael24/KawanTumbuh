import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_assets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Model pesan
// ─────────────────────────────────────────────────────────────────────────────
class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  _ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? time,
  }) : time = time ?? DateTime.now();
}

// ─────────────────────────────────────────────────────────────────────────────
// Quick reply suggestions — pertanyaan cepat yang bisa dipilih anak/orang tua
// ─────────────────────────────────────────────────────────────────────────────
const List<String> _kQuickReplies = [
  '🌱 Apa itu Disleksia?',
  '🔢 Apa itu Diskalkulia?',
  '✏️ Apa itu Disgrafia?',
  '📋 Cara mulai skrining',
  '🎯 Tips belajar anak',
];

// Jawaban dummy — nanti diganti dengan pemanggilan API nyata
const Map<String, String> _kDummyAnswers = {
  '🌱 Apa itu Disleksia?':
      'Disleksia adalah kesulitan membaca yang memengaruhi kemampuan anak mengenali kata dan ejaan, meskipun kecerdasannya normal. Anak dengan disleksia bisa belajar dengan cara yang tepat! 📚',
  '🔢 Apa itu Diskalkulia?':
      'Diskalkulia adalah kesulitan memahami angka dan operasi matematika. Bukan karena anak malas — otaknya butuh pendekatan belajar yang berbeda. Kita bisa bantu! 🔢',
  '✏️ Apa itu Disgrafia?':
      'Disgrafia adalah kesulitan menulis tangan — hurufnya tidak rapi atau sulit mengekspresikan pikiran lewat tulisan. Dengan latihan dan dukungan, anak bisa berkembang! ✏️',
  '📋 Cara mulai skrining':
      'Kamu bisa mulai skrining lewat menu "Skrining" di halaman utama. Isi kuesioner singkat dan aku akan bantu analisis hasilnya bersama kamu! 🌟',
  '🎯 Tips belajar anak':
      'Beberapa tips ampuh: gunakan warna-warni saat belajar, bagi materi jadi bagian kecil, beri pujian setiap kemajuan kecil, dan istirahat teratur. Semangat! 💪',
};

// ─────────────────────────────────────────────────────────────────────────────
// Screen utama
// ─────────────────────────────────────────────────────────────────────────────
class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<_ChatMessage> _messages = [];
  bool _isTyping = false; // animasi "Sprout sedang mengetik..."

  // Warna utama — sinkron dengan AppColors
  static const Color _teal = Color(0xFF5F8F8A);
  static const Color _tealLight = Color(0xFFE8F2F1);
  static const Color _bgCream = Color(0xFFF5F0E8);
  static const Color _textDark = Color(0xFF1A1A1A);
  static const Color _textMuted = Color(0xFF7A7A7A);

  @override
  void initState() {
    super.initState();
    // Pesan selamat datang dari Sprout
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(
            text:
                'Halo! 👋 Aku Sprout, teman belajarmu di KawanTumbuh!\n\nAku siap bantu kamu memahami tentang Disleksia, Disgrafia, dan Diskalkulia. Mau tanya apa hari ini? 🌱',
            isUser: false,
          ));
        });
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── Kirim pesan ──────────────────────────────────────────────────────────
  void _sendMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: trimmed, isUser: true));
      _textController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulasi delay bot mengetik (nanti diganti API call)
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final answer = _kDummyAnswers[trimmed] ??
          'Wah, pertanyaan bagus! 🌟 Untuk saat ini aku masih belajar menjawab itu. Coba tanya yang lain atau pilih dari saran di bawah ya!';
      setState(() {
        _isTyping = false;
        _messages.add(_ChatMessage(text: answer, isUser: false));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgCream,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    // Bubble "Sprout sedang mengetik..."
                    return _buildTypingIndicator();
                  }
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
          ),
          // Quick replies
          _buildQuickReplies(),
          // Input area
          _buildInputArea(),
        ],
      ),
    );
  }

  // ── AppBar ───────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _teal,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          // Avatar Sprout kecil di AppBar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                AppAssets.maskotSprout,
                fit: BoxFit.contain,
                errorBuilder: (ctx, e, st) => const Icon(
                  Icons.eco_rounded,
                  color: Color(0xFF5F8F8A),
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sprout',
                style: GoogleFonts.quicksand(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF8FE0C0),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Online',
                    style: GoogleFonts.quicksand(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded,
              color: Colors.white, size: 22),
          onPressed: () {},
        ),
      ],
    );
  }

  // ── Bubble pesan ─────────────────────────────────────────────────────────
  Widget _buildMessageBubble(_ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isUser) _buildSproutAvatar(),
          if (!msg.isUser) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: msg.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: msg.isUser ? _teal : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(msg.isUser ? 18 : 4),
                      bottomRight: Radius.circular(msg.isUser ? 4 : 18),
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
                            color: _teal.withValues(alpha: 0.2),
                            width: 1,
                          ),
                  ),
                  child: Text(
                    msg.text,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: msg.isUser ? Colors.white : _textDark,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatTime(msg.time),
                  style: GoogleFonts.quicksand(
                    fontSize: 10,
                    color: _textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (msg.isUser) const SizedBox(width: 8),
          if (msg.isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  // ── Avatar Sprout kecil di samping bubble bot ────────────────────────────
  Widget _buildSproutAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset(
          AppAssets.maskotSprout,
          fit: BoxFit.contain,
          errorBuilder: (ctx, e, st) => const Icon(
            Icons.eco_rounded,
            color: Color(0xFF5F8F8A),
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: _teal.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person_rounded, color: _teal, size: 18),
    );
  }

  // ── Indikator "Sprout sedang mengetik" ───────────────────────────────────
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildSproutAvatar(),
          const SizedBox(width: 8),
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
              border: Border.all(
                color: _teal.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _TypingDots(),
          ),
        ],
      ),
    );
  }

  // ── Quick replies ────────────────────────────────────────────────────────
  Widget _buildQuickReplies() {
    return Container(
      color: _bgCream,
      padding: const EdgeInsets.fromLTRB(16, 6, 0, 6),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _kQuickReplies.length,
          separatorBuilder: (_, i) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _sendMessage(_kQuickReplies[index]),
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
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  _kQuickReplies[index],
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _teal,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Input area ───────────────────────────────────────────────────────────
  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _tealLight,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _textDark,
                ),
                decoration: InputDecoration(
                  hintText: 'Tanya Sprout sesuatu...',
                  hintStyle: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _textMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                ),
                onSubmitted: _sendMessage,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Tombol kirim
          GestureDetector(
            onTap: () => _sendMessage(_textController.text),
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
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animasi titik-titik "mengetik"
// ─────────────────────────────────────────────────────────────────────────────
class _TypingDots extends StatefulWidget {
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            // Setiap titik melambat naik secara bergantian
            final double phase = ((_controller.value * 3) - i).clamp(0.0, 1.0);
            final double offset = (phase < 0.5 ? phase : 1.0 - phase) * 6.0;
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
        );
      },
    );
  }
}
