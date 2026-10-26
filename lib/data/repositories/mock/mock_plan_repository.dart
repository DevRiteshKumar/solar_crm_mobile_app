import '../../../core/constants/app_constants.dart';
import '../../mock/mock_data.dart';
import '../../models/membership_plan.dart';
import '../plan_repository.dart';

class MockPlanRepository implements PlanRepository {
  @override
  Future<List<MembershipPlan>> getPlans() async {
    await Future.delayed(AppConstants.mockDelay);
    return List.from(MockData.plans);
  }

  @override
  Future<void> selectPlan(String planId) async {
    await Future.delayed(AppConstants.mockDelay);
  }
}
