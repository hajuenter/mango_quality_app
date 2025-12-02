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
  RxBool isLoadingBubble = false.obs;

  // 🔥 TAMBAHAN: Timer untuk kontrol async operations
  Timer? _welcomeTimer;
  Timer? _loadingTimer;
  bool _isClearing = false; // Flag untuk mencegah race condition

  @override
  void onClose() {
    // Bersihkan timer saat controller di dispose
    _cancelAllTimers();
    super.onClose();
  }

  void _cancelAllTimers() {
    _welcomeTimer?.cancel();
    _loadingTimer?.cancel();
    _welcomeTimer = null;
    _loadingTimer = null;
  }

  void addLoadingBubble() {
    if (isLoadingBubble.value || _isClearing) return;

    isLoadingBubble.value = true;
    messages.add(MangoAiModel(sender: "bot", text: "...", isLoading: true));
  }

  void removeLoadingBubble() {
    if (!isLoadingBubble.value) return;

    if (messages.isNotEmpty && messages.last.isLoading) {
      messages.removeLast();
    }

    isLoadingBubble.value = false;
  }

  void onWelcomeFinished() async {
    if (_isClearing) return;

    showWelcome.value = false;

    _cancelAllTimers();

    addLoadingBubble();

    _loadingTimer = Timer(const Duration(seconds: 1), () {
      if (_isClearing) return;

      removeLoadingBubble();
      sendInitialOptions();
    });
  }

  void sendInitialOptions() {
    if (_isClearing) return;

    if (messages.isNotEmpty &&
        messages.last.text.contains('Silakan pilih kebutuhan Anda:')) {
      return;
    }

    messages.add(
      MangoAiModel(
        sender: 'bot',
        text: """
Halo! Silakan pilih kebutuhan Anda:
1. Penjelasan bagaimana sistem monitoring Mango Sort bekerja
2. Ciri-ciri mangga yang sehat dan berkualitas baik
3. Ciri-ciri mangga yang busuk atau tidak layak konsumsi
4. Cara menjalankan sistem pendeteksian dan penyortiran Mango Sort
5. Bebas bertanya mengenai apa pun
    """,
      ),
    );
    isFreeMode.value = false;
  }

  void clearChat() {
    _isClearing = true;

    _cancelAllTimers();

    messages.clear();
    isFreeMode.value = false;
    showWelcome.value = true;
    isLoadingBubble.value = false;
    isTyping.value = false;

    Future.delayed(const Duration(milliseconds: 100), () {
      _isClearing = false;
    });
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _isClearing) return;

    messages.add(MangoAiModel(sender: 'user', text: text));

    if (!isFreeMode.value) {
      if (!(["1", "2", "3", "4", "5"].contains(text))) {
        _botReply("⚠️ Silakan pilih opsi 1–5 terlebih dahulu.");
        return;
      }

      addLoadingBubble();

      _loadingTimer = Timer(const Duration(seconds: 2), () {
        if (_isClearing) return;

        removeLoadingBubble();

        if (text == "5") {
          isFreeMode.value = true;
          _botReply("Anda masuk mode tanya bebas. Silakan bertanya.");
          return;
        }

        switch (text) {
          case "1":
            _botReply(
              "Berikut penjelasan bagaimana aplikasi monitoring Mango Sort bekerja:\n\n"
              "1. **Terhubung dengan perangkat keras melalui internet**\n"
              "- Aplikasi terhubung langsung dengan alat pendeteksi mangga di lapangan.\n"
              "- Sistem dapat dipantau dari jarak jauh secara real-time.\n\n"
              "2. **Menampilkan hasil deteksi secara langsung (realtime)**\n"
              "- Setiap mangga yang terdeteksi oleh perangkat keras akan otomatis muncul di menu aktivitas realtime.\n"
              "- Status seperti 'Sehat' atau 'Busuk' ditampilkan langsung pada aplikasi.\n\n"
              "3. **Memiliki fitur musim (panen)**\n"
              "- Pengguna dapat memulai musim dari halaman beranda dengan menginput nama musim.\n"
              "- Selama musim masih aktif, setiap mangga yang terdeteksi akan masuk ke musim tersebut.\n"
              "- Musim dapat diakhiri dari halaman yang sama ketika pengguna selesai.\n\n"
              "4. **Statistik pemantauan panen**\n"
              "- Aplikasi menampilkan grafik jumlah mangga sehat dan busuk.\n"
              "- Statistik dapat dilihat per hari, bulan, dan tahun.\n\n"
              "5. **Fitur unduh laporan**\n"
              "- Pengguna dapat mengunduh laporan panen dalam bentuk PDF.\n"
              "- Laporan dapat diunduh berdasarkan musim tertentu.\n\n"
              "6. **Detail musim panen sebelumnya**\n"
              "- Terdapat daftar musim yang pernah dibuat pengguna.\n"
              "- Setiap musim menampilkan jumlah mangga yang berhasil terdeteksi.\n"
              "- Termasuk gambar hasil deteksi dari perangkat keras.\n\n"
              "7. **Fitur Chatbot Mango AI**\n"
              "- Pengguna dapat bertanya seputar mangga, sistem, atau informasi lain langsung di aplikasi.\n\n"
              "8. **Pengaturan dan informasi aplikasi**\n"
              "- Berisi menu tentang aplikasi, kebijakan privasi, panduan pengguna, dan pengaturan lainnya.\n\n"
              "Dengan aplikasi ini, pengguna dapat memantau proses pendeteksian mangga tanpa harus berada di lokasi alat secara langsung.",
            );
            break;

          case "2":
            _botReply(
              "Berikut ciri-ciri mangga sehat dan berkualitas baik:\n\n"
              "1. **Kulit bersih, cerah, dan tidak rusak**\n"
              "- Warna sesuai varietas dan tidak kusam.\n\n"
              "2. **Tekstur kulit mulus**\n"
              "- Tidak ada luka besar atau bercak luas.\n\n"
              "3. **Aroma segar dan manis**\n"
              "- Terutama pada mangga matang.\n\n"
              "4. **Daging buah padat dan tidak lembek**\n"
              "- Ketika ditekan sedikit masih terasa kenyal.\n\n"
              "5. **Tidak ada tanda jamur atau pembusukan**\n\n"
              "Ciri-ciri ini biasa digunakan sistem AI untuk menilai apakah mangga layak konsumsi.",
            );
            break;

          case "3":
            _botReply(
              "Berikut ciri-ciri mangga busuk atau tidak layak konsumsi:\n\n"
              "1. **Tekstur sangat lembek atau rusak**\n"
              "- Terasa penyok ketika ditekan.\n\n"
              "2. **Bercak hitam atau coklat luas pada kulit**\n"
              "- Menandakan kerusakan atau proses pembusukan.\n\n"
              "3. **Terdapat jamur pada permukaan kulit**\n"
              "- Misalnya bercak putih, hijau, atau keabu-abuan.\n\n"
              "4. **Aroma tidak sedap atau asam menyengat**\n"
              "- Tanda fermentasi dan pembusukan.\n\n"
              "5. **Bagian dalam buah berwarna kecoklatan**\n"
              "- Biasanya baru terlihat setelah dibelah.\n\n"
              "Sistem Mango Sort juga menggunakan pola visual ini untuk mendeteksi kualitas mangga.",
            );
            break;

          case "4":
            _botReply(
              "Berikut cara kerja perangkat keras Mango Sort pada proses pendeteksian dan penyortiran mangga:\n\n"
              "1. **Menghidupkan alat**\n"
              "- Nyalakan perangkat keras sehingga conveyor, sensor, kamera, dan ESP32 mulai aktif.\n\n"
              "2. **Mangga diletakkan di atas conveyor**\n"
              "- Conveyor mulai bergerak membawa mangga menuju area pemindaian.\n\n"
              "3. **Sensor ultrasonik mendeteksi posisi mangga**\n"
              "- Ketika mangga sudah berada tepat di atas kamera, sensor ultrasonik memberikan sinyal.\n"
              "- Conveyor otomatis berhenti agar proses pengambilan gambar tepat dan stabil.\n\n"
              "4. **Kamera/webcam mengambil gambar mangga**\n"
              "- Kamera yang terpasang di atas conveyor memotret mangga.\n\n"
              "5. **ESP32 mengirim gambar ke server**\n"
              "- Foto dikirim melalui internet ke server atau cloud yang menjalankan model AI.\n\n"
              "6. **Server menganalisis gambar**\n"
              "- Model AI menentukan apakah mangga sehat atau busuk sesuai hasil deteksi.\n\n"
              "7. **Hasil dikirim kembali ke aplikasi Mango Sort**\n"
              "- Aplikasi menampilkan status secara real-time pada menu aktivitas monitoring.\n\n"
              "Dengan sistem ini, proses pemeriksaan mangga dapat berjalan otomatis tanpa harus dilakukan secara manual.",
            );
            break;
        }
      });
      return;
    }

    addLoadingBubble();
    isTyping.value = true;

    try {
      final reply = await _service.sendToGemini(text);

      if (_isClearing) return;

      removeLoadingBubble();
      isTyping.value = false;

      _botReply(reply);
    } catch (e) {
      if (_isClearing) return;

      removeLoadingBubble();
      isTyping.value = false;
      _botReply("Terjadi kesalahan: $e");
    }
  }

  void _botReply(String text) {
    if (_isClearing) return;
    messages.add(MangoAiModel(sender: 'bot', text: text));
  }
}
