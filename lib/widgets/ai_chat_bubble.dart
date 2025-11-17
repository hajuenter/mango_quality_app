import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mango_app/config/colors.dart';
import 'package:mango_app/helpers/markdown_utils.dart';
import 'package:mango_app/helpers/date_formatter.dart';
import 'package:mango_app/models/mango_ai_model.dart';

class AiChatBubble extends StatelessWidget {
  final MangoAiModel msg;
  final bool isUser;

  const AiChatBubble({super.key, required this.msg, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: isUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            // Avatar AI
            if (!isUser)
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                child: Icon(Icons.smart_toy, color: Colors.white),
              ),

            if (!isUser) const SizedBox(width: 8),

            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                margin: isUser
                    ? const EdgeInsets.only(left: 40)
                    : const EdgeInsets.only(right: 40),
                decoration: BoxDecoration(
                  color: isUser ? AppColors.primaryAuth : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: msg.isLoading
                    ? SizedBox(
                        width: 45,
                        height: 20,
                        child: SpinKitThreeBounce(
                          size: 15,
                          color: Colors.black54,
                        ),
                      )
                    : Text(
                        markdownToPlainText(msg.text),
                        style: GoogleFonts.rubik(
                          fontSize: 15,
                          color: isUser ? Colors.white : Colors.black87,
                        ),
                      ),
              ),
            ),

            if (isUser) const SizedBox(width: 8),

            // Avatar User
            if (isUser)
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white),
              ),
          ],
        ),

        const SizedBox(height: 4),

        // TANGGAL ➜ ikut margin bubble
        Padding(
          padding: EdgeInsets.only(
            left: isUser ? 0 : 48,
            right: isUser ? 48 : 0,
          ),
          child: Text(
            formatChatDate(msg.timestamp),
            style: GoogleFonts.rubik(fontSize: 11, color: Colors.grey.shade500),
          ),
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}
