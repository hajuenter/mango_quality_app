import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/colors.dart';
import '../../controllers/mango_ai_controller.dart';
import '../../widgets/ai_chat_bubble.dart';
import '../../widgets/ai_input_bar.dart';
import '../../widgets/ai_welcome_section.dart';

class MangoAiPage extends StatefulWidget {
  const MangoAiPage({super.key});

  @override
  State<MangoAiPage> createState() => _MangoAiPageState();
}

class _MangoAiPageState extends State<MangoAiPage> {
  final MangoAiController c = Get.put(MangoAiController());
  final TextEditingController inputC = TextEditingController();
  final ScrollController scrollC = ScrollController();

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (scrollC.hasClients) {
        scrollC.animateTo(
          scrollC.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApk,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                color: AppColors.primaryAuth,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Text(
                'Asisten Pintar Mangga',
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Expanded(
              child: Obx(() {
                if (c.showWelcome.value) {
                  return AiWelcomeSection(onFinish: c.onWelcomeFinished);
                }

                if (c.messages.isNotEmpty) {
                  scrollToBottom();
                }

                return ListView.builder(
                  controller: scrollC,
                  padding: const EdgeInsets.all(16),
                  itemCount: c.messages.length,
                  itemBuilder: (context, i) {
                    final msg = c.messages[i];
                    return AiChatBubble(msg: msg, isUser: msg.sender == "user");
                  },
                );
              }),
            ),

            AiInputBar(inputC: inputC, scrollToBottom: scrollToBottom),
          ],
        ),
      ),
    );
  }
}
