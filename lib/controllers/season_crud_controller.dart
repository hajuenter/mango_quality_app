import 'package:get/get.dart';
import '../models/season_crud_model.dart';
import '../services/season_crud_service.dart';

class SeasonCrudController extends GetxController {
  final SeasonCrudService _service = SeasonCrudService();

  Rx<SeasonCrudModel?> activeSeason = Rx<SeasonCrudModel?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    loadActiveSeason();
    super.onInit();
  }

  Future<void> loadActiveSeason() async {
    isLoading.value = true;
    activeSeason.value = await _service.getActiveSeason();
    isLoading.value = false;
  }

  Future<String?> startSeason(String name) async {
    isLoading.value = true;
    final result = await _service.startSeason(name);
    await loadActiveSeason();
    isLoading.value = false;
    return result; // null = sukses
  }

  Future<String?> stopSeason() async {
    isLoading.value = true;
    final result = await _service.stopSeason();
    await loadActiveSeason();
    isLoading.value = false;
    return result;
  }
}
