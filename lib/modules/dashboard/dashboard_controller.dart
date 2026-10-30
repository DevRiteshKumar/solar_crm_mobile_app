import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../data/models/dashboard_stats.dart';
import '../../data/models/lead.dart';
import '../../data/repositories/dashboard_repository.dart';

class DashboardController extends GetxController {
  final DashboardRepository _repository = Get.find();

  final isLoading = true.obs;
  final stats = Rxn<DashboardStats>();
  final dateRangeLabel = '11 Sep – 17 Sep 2026'.obs;
  final selectedSection = 'Status'.obs;

  static const sectionTabs = [
    'Status',
    'Priority',
    'Overview',
    'Financials',
    'Next Step',
    'Completed',
  ];

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    try {
      isLoading.value = true;
      stats.value = await _repository.getStats();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard');
    } finally {
      isLoading.value = false;
    }
  }

  void selectSection(String section) => selectedSection.value = section;

  List<Lead> leadsForSection(DashboardStats s) {
    switch (selectedSection.value) {
      case 'Priority':
        return s.leadsByPriority;
      case 'Overview':
        return s.leadOverview;
      case 'Financials':
        return s.leadFinancials;
      case 'Next Step':
        return s.leadsByNextStep;
      case 'Completed':
        return s.leadsCompleted;
      case 'Status':
      default:
        return s.leadsByStatus;
    }
  }

  String sectionTitle() {
    switch (selectedSection.value) {
      case 'Priority':
        return 'Leads By Priority';
      case 'Overview':
        return 'Lead Overview';
      case 'Financials':
        return 'Lead Financials';
      case 'Next Step':
        return 'Leads By Next Step';
      case 'Completed':
        return 'Leads Completed';
      case 'Status':
      default:
        return 'Leads By Status';
    }
  }

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void openAddLead() {
    Get.toNamed(AppRoutes.leadForm);
  }

  void replaceLead(Lead lead) {
    final current = stats.value;
    if (current == null) return;
    List<Lead> swap(List<Lead> list) => list.map((l) => l.id == lead.id ? lead : l).toList();
    stats.value = DashboardStats(
      totalLeads: current.totalLeads,
      totalContacts: current.totalContacts,
      totalReferrers: current.totalReferrers,
      totalTasks: current.totalTasks,
      userName: current.userName,
      planExpiryMessage: current.planExpiryMessage,
      leadsByStatus: swap(current.leadsByStatus),
      leadsByPriority: swap(current.leadsByPriority),
      leadOverview: swap(current.leadOverview),
      leadFinancials: swap(current.leadFinancials),
      leadsByNextStep: swap(current.leadsByNextStep).where((l) => l.nextStep != 'Completed').toList(),
      leadsCompleted: swap(current.leadsCompleted).where((l) => l.nextStep == 'Completed').toList(),
    );
  }

  void extendTrial() {
    Get.snackbar(
      'Extend Free Trial',
      'Request submitted (mock).',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void allPackages() {
    Get.toNamed(AppRoutes.membershipPlans);
  }
}
