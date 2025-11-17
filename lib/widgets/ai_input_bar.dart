import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mango_app/config/colors.dart';
import 'package:mango_app/controllers/mango_ai_controller.dart';

class AiInputBar extends StatelessWidget {
  final TextEditingController inputC;
  final VoidCallback scrollToBottom;

  AiInputBar({super.key, required this.inputC, required this.scrollToBottom});

  final FocusNode inputFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final MangoAiController c = Get.find();

    // Auto scroll ketika TextField difokuskan
    inputFocus.addListener(() {
      if (inputFocus.hasFocus && !c.showWelcome.value) {
        Future.delayed(const Duration(milliseconds: 150), scrollToBottom);
      }
    });

    return Obx(() {
      final bool isWelcome = c.showWelcome.value;

      return Container(
        padding: const EdgeInsets.all(12),
        color: Colors.white70,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: inputC,
                focusNode: isWelcome
                    ? null
                    : inputFocus, // ⛔ nonaktif saat welcome
                readOnly: isWelcome, // ⛔ tidak bisa mengetik
                enabled: !isWelcome,
                decoration: InputDecoration(
                  hintText: isWelcome ? "Tunggu sebentar..." : "Ketik pesan...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 6),

            // SEND BUTTON
            InkWell(
              onTap: isWelcome
                  ? null // ⛔ tombol mati saat welcome
                  : () {
                      if (inputC.text.trim().isEmpty) return;
                      c.sendMessage(inputC.text.trim());
                      inputC.clear();
                      scrollToBottom();
                    },
              child: Icon(
                Icons.send,
                size: 26,
                color: isWelcome ? Colors.grey.shade400 : AppColors.primaryAuth,
              ),
            ),

            const SizedBox(width: 6),

            // DELETE BUTTON
            InkWell(
              onTap: isWelcome || c.messages.isEmpty ? null : c.clearChat,
              child: Icon(
                Icons.delete,
                size: 26,
                color: isWelcome || c.messages.isEmpty
                    ? Colors.grey.shade400
                    : Colors.redAccent,
              ),
            ),
          ],
        ),
      );
    });
  }
}
