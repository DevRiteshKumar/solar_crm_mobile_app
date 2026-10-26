import 'package:get/get.dart';
import '../../data/models/membership_plan.dart';
import '../../data/repositories/plan_repository.dart';

class MembershipPlansController extends GetxController {
  final PlanRepository _repository = Get.find();

  final isLoading = false.obs;
  final plans = <MembershipPlan>[].obs;
  final selectedPlanId = RxnString();
  final expandedPlanIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    try {
      isLoading.value = true;
      plans.assignAll(await _repository.getPlans());
    } finally {
      isLoading.value = false;
    }
  }

  void toggleExpanded(String planId) {
    if (expandedPlanIds.contains(planId)) {
      expandedPlanIds.remove(planId);
    } else {
      expandedPlanIds.add(planId);
    }
  }

  Future<void> selectPlan(MembershipPlan plan) async {
    await _repository.selectPlan(plan.id);
    selectedPlanId.value = plan.id;
    Get.snackbar(
      'Plan selected',
      '${plan.name} is now your active plan (mock)',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
