import 'package:get/get.dart';
import '../../data/models/referral.dart';
import '../../data/repositories/referral_repository.dart';

class ReferralsController extends GetxController {
  final ReferralRepository _repository = Get.find();

  final isLoading = false.obs;
  final referrals = <Referral>[].obs;
  final dateRangeLabel = 'Date Range'.obs;
  final showSearch = false.obs;
  final selectedFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void toggleSearch() => showSearch.toggle();

  Future<void> load({String? query}) async {
    try {
      isLoading.value = true;
      referrals.assignAll(await _repository.getReferrals(query: query));
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String q) => load(query: q);
}
