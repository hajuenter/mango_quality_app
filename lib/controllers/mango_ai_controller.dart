import 'dart:async';
import 'package:get/get.dart';
import '../models/mango_ai_model.dart';
import '../services/mango_ai_service.dart';

class MangoAiController extends GetxController {
  final MangoAiService _service = MangoAiService();

  RxList<MangoAiModel> messages = <MangoAiModel>[].obs;
  RxBool isTyping = false.obs;
  RxBool isFreeMode = false.obs;

  RxBool showWelcome = true.obs;

  /// Welcome selesai → tampilkan animasi "..."
  void onWelcomeFinished() async {
    showWelcome.value = false;

    // 1. Tampilkan "..." loading sebelum pesan awal
    messages.add(MangoAiModel(sender: "bot", text: "...", isLoading: true));

    await Future.delayed(const Duration(seconds: 1));

    // 2. Hapus "..."
    messages.removeLast();

    // 3. Kirim pesan pilihan awal
    sendInitialOptions();
  }

  void sendInitialOptions() {
    messages.add(
      MangoAiModel(
        sender: 'bot',
        text: """
Halo! Pilih bantuan:
1. Cara menanam mangga
2. Cara merawat mangga
3. Ciri-ciri mangga sehat dan busuk
4. Hama dan penyakit umum pada mangga
5. Tanya bebas apa saja
        """,
      ),
    );
    isFreeMode.value = false;
  }

  void clearChat() {
    messages.clear();
    isFreeMode.value = false;
    showWelcome.value = true;
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    messages.add(MangoAiModel(sender: 'user', text: text));

    if (!isFreeMode.value) {
      if (!(["1", "2", "3", "4", "5"].contains(text))) {
        _botReply("⚠️ Silakan pilih opsi 1–5 terlebih dahulu.");
        return;
      }

      if (text != "5") {
        await _showLoadingDelay();
        switch (text) {
          case "1":
            _botReply(
              "Cara menanam mangga yang baik dan benar agar tanaman dapat tumbuh subur dan cepat berbuah:\n\n"
              "1. **Pilih Bibit Unggul:**\n"
              "- Gunakan bibit dari varietas yang sesuai dengan kondisi tanah di daerah Anda.\n"
              "- Pastikan bibit tidak terkena penyakit dan memiliki batang yang kuat.\n\n"
              "2. **Persiapkan Media Tanam:**\n"
              "- Gunakan tanah gembur yang kaya unsur hara.\n"
              "- Campurkan pupuk kandang atau kompos untuk menambah nutrisi.\n\n"
              "3. **Jarak Tanam yang Ideal:**\n"
              "- Jika menanam lebih dari satu pohon, beri jarak 5–7 meter agar tidak saling berebut nutrisi.\n\n"
              "4. **Penanaman:**\n"
              "- Gali lubang 50–60 cm.\n"
              "- Masukkan bibit dan pastikan akar tidak terlipat.\n"
              "- Tutup lubang dan padatkan perlahan.\n\n"
              "5. **Penyiraman:**\n"
              "- Siram secara rutin 1–2 kali sehari terutama di minggu awal.\n\n"
              "Dengan teknik yang tepat, bibit mangga biasanya mulai menunjukkan pertumbuhan pesat dalam 2–4 minggu pertama.",
            );
            return;

          case "2":
            _botReply(
              "Cara merawat pohon mangga agar tetap sehat dan cepat berbuah:\n\n"
              "1. **Penyiraman Teratur:**\n"
              "- Siram 1–2 kali sehari saat masa pertumbuhan.\n"
              "- Pada musim hujan, kurangi intensitas agar tanah tidak terlalu lembap.\n\n"
              "2. **Pemupukan:**\n"
              "- Gunakan pupuk NPK seimbang (misal NPK 16-16-16) tiap 1–2 bulan sekali.\n"
              "- Tambahkan pupuk kandang untuk meningkatkan kesuburan tanah.\n\n"
              "3. **Pemangkasan:**\n"
              "- Pangkas ranting mati atau yang berpenyakit.\n"
              "- Bentuk tajuk agar sinar matahari bisa masuk maksimal.\n\n"
              "4. **Pengendalian Hama:**\n"
              "- Periksa daun secara berkala.\n"
              "- Jika ada tanda kutu atau jamur, semprot dengan pestisida organik.\n\n"
              "Jika dirawat dengan baik, pohon mangga bisa mulai berbunga dalam 2–4 tahun tergantung varietas.",
            );
            return;

          case "3":
            _botReply(
              "Berikut ciri-ciri mangga sehat dan mangga yang mulai rusak (busuk) agar Anda dapat membedakan saat memanen atau memilih buah:\n\n"
              "### 🍃 **Ciri-ciri Mangga Sehat:**\n"
              "1. **Kulit bersih dan cerah** tanpa bercak hitam besar.\n"
              "2. **Aroma harum alami**, menandakan mulai matang.\n"
              "3. **Tekstur agak lunak** saat ditekan perlahan.\n"
              "4. **Warna kulit merata**, sesuai jenis mangga.\n"
              "5. **Tidak ada getah berlebihan**, karena getah biasanya muncul pada buah yang baru dipetik.\n\n"
              "### ❌ **Ciri-ciri Mangga Busuk:**\n"
              "1. Kulit memiliki **banyak bercak hitam**, lembek, atau pecah.\n"
              "2. Tercium aroma **asam atau fermentasi**.\n"
              "3. Tekstur sangat lembek dan berair.\n"
              "4. Bisa muncul **jamur putih** pada permukaan.\n"
              "5. Bagian dalam buah kecoklatan atau berair.\n\n"
              "Mengenali ciri ini membuat Anda lebih mudah memilih buah berkualitas di pasar maupun menentukan waktu panen terbaik.",
            );
            return;

          case "4":
            _botReply(
              "Berikut hama dan penyakit mangga paling umum serta cara mengatasinya:\n\n"
              "### 🐛 **Hama pada Mangga:**\n"
              "1. **Kutu Putih:**\n"
              "- Menempel pada daun dan menghisap cairan.\n"
              "- Atasi dengan sabun insektisida atau minyak neem.\n\n"
              "2. **Wereng:**\n"
              "- Menyebabkan daun menguning dan rontok.\n"
              "- Gunakan pestisida organik seperti ekstrak bawang putih.\n\n"
              "3. **Ulat Daun:**\n"
              "- Memakan daun muda hingga habis.\n"
              "- Kumpulkan manual atau semprot biopestisida.\n\n"
              "### 🍂 **Penyakit pada Mangga:**\n"
              "1. **Antraknosa (Jamur):**\n"
              "- Menyebabkan bercak hitam pada buah dan daun.\n"
              "- Semprot fungisida organik secara berkala.\n\n"
              "2. **Busuk Bunga (Powdery Mildew):**\n"
              "- Menyerang bunga sehingga gagal menjadi buah.\n"
              "- Gunakan larutan susu + air (rasio 1:9) sebagai fungisida alami.\n\n"
              "Perawatan rutin dapat mencegah serangan lebih parah dan menjaga produktivitas pohon.",
            );
            return;
        }
      }

      if (text == "5") {
        isFreeMode.value = true;
        _botReply(
          "Anda masuk mode tanya bebas seputar buah Mangga, silahkan bertanya.",
        );
        return;
      }
    }

    messages.add(MangoAiModel(sender: 'bot', text: "...", isLoading: true));
    isTyping.value = true;

    final reply = await _service.sendToGemini(text);

    messages.removeLast();

    messages.add(MangoAiModel(sender: 'bot', text: reply));
    isTyping.value = false;
  }

  void _botReply(String text) {
    messages.add(MangoAiModel(sender: 'bot', text: text));
  }

  Future<void> _showLoadingDelay() async {
    messages.add(MangoAiModel(sender: 'bot', text: "...", isLoading: true));
    await Future.delayed(const Duration(seconds: 2));
    messages.removeLast();
  }
}
