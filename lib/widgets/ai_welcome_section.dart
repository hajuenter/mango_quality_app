import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AiWelcomeSection extends StatefulWidget {
  final VoidCallback onFinish; // 🔥 callback elegan

  const AiWelcomeSection({super.key, required this.onFinish});

  @override
  State<AiWelcomeSection> createState() => _AiWelcomeSectionState();
}

class _AiWelcomeSectionState extends State<AiWelcomeSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _bounceAnimation;

  bool showLoading = true;

  String fullText = "Selamat datang di\nAsisten Mangga Pintar";
  String displayedText = "";
  int textIndex = 0;

  @override
  void initState() {
    super.initState();

    _iconController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );

    // Loading → Typewriter → Trigger
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => showLoading = false);

      Future.delayed(const Duration(milliseconds: 200), typeWriterEffect);
    });
  }

  void typeWriterEffect() {
    Future.delayed(const Duration(milliseconds: 40), () {
      if (!mounted) return;

      if (textIndex < fullText.length) {
        setState(() {
          displayedText += fullText[textIndex];
          textIndex++;
        });
        typeWriterEffect();
      } else {
        // 🔥 Paling elegan: callback setelah ketik selesai
        Future.delayed(const Duration(milliseconds: 300), () {
          widget.onFinish();
        });
      }
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _bounceAnimation.value),
                child: child,
              );
            },
            child: Icon(Icons.smart_toy, size: 90, color: Colors.grey.shade500),
          ),

          const SizedBox(height: 12),

          if (!showLoading)
            Text(
              displayedText,
              textAlign: TextAlign.center,
              style: GoogleFonts.rubik(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
        ],
      ),
    );
  }
}
