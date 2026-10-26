import '../models/membership_plan.dart';

abstract class PlanRepository {
  Future<List<MembershipPlan>> getPlans();

  Future<void> selectPlan(String planId);
}
