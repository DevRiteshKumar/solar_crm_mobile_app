import 'package:get/get.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/contact_repository.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../data/repositories/lead_repository.dart';
import '../../data/repositories/plan_repository.dart';
import '../../data/repositories/referral_repository.dart';
import '../../data/repositories/role_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/mock/mock_auth_repository.dart';
import '../../data/repositories/mock/mock_contact_repository.dart';
import '../../data/repositories/mock/mock_dashboard_repository.dart';
import '../../data/repositories/mock/mock_lead_repository.dart';
import '../../data/repositories/mock/mock_plan_repository.dart';
import '../../data/repositories/mock/mock_referral_repository.dart';
import '../../data/repositories/mock/mock_role_repository.dart';
import '../../data/repositories/mock/mock_user_repository.dart';
import '../../modules/leads/lead_options_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Swap Mock* with Api* implementations after UI approval.
    Get.put<AuthRepository>(MockAuthRepository(), permanent: true);
    Get.put<DashboardRepository>(MockDashboardRepository(), permanent: true);
    Get.put<LeadRepository>(MockLeadRepository(), permanent: true);
    Get.put<ContactRepository>(MockContactRepository(), permanent: true);
    Get.put<ReferralRepository>(MockReferralRepository(), permanent: true);
    Get.put<UserRepository>(MockUserRepository(), permanent: true);
    Get.put<RoleRepository>(MockRoleRepository(), permanent: true);
    Get.put<PlanRepository>(MockPlanRepository(), permanent: true);
    Get.put(LeadOptionsController(), permanent: true);
  }
}
