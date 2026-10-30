import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_routes.dart';
import '../../data/models/lead.dart';
import '../../data/repositories/lead_repository.dart';
import '../leads/leads_controller.dart';

class ReferralLeadsController extends GetxController {
  final LeadRepository _repository = Get.find();

  final isLoading = false.obs;
  final leads = <Lead>[].obs;
  final searchQuery = ''.obs;
  final showSearch = false.obs;
  final sortLabel = 'Last Contact'.obs;

  LeadsController? get _leads =>
      Get.isRegistered<LeadsController>() ? Get.find<LeadsController>() : null;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    try {
      isLoading.value = true;
      leads.assignAll(
        await _repository.getLeads(
          query: searchQuery.value,
          filter: 'Referral Leads',
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSearch() => showSearch.toggle();

  void onSearch(String q) {
    searchQuery.value = q;
    load();
  }

  bool isCheckedIn(String id) => _leads?.checkedInIds.contains(id) ?? false;

  void openLeadDetail(Lead lead, {int tab = 0}) {
    Get.toNamed(AppRoutes.leadDetail, arguments: {'lead': lead, 'tab': tab});
  }

  void openLeadItems(Lead lead, String type) {
    final tab = switch (type) {
      'Tasks' => 1,
      'Notes' => 2,
      'Calls' => 3,
      'Files' => 4,
      _ => 0,
    };
    openLeadDetail(lead, tab: tab);
  }

  void editLead(Lead lead) => Get.toNamed(AppRoutes.leadForm, arguments: lead);

  void addLead() => Get.toNamed(AppRoutes.leadForm);

  Future<void> patchLead(Lead lead) async {
    final index = leads.indexWhere((l) => l.id == lead.id);
    if (index >= 0) {
      if (lead.source.toLowerCase() != 'referrals') {
        leads.removeAt(index);
      } else {
        leads[index] = lead;
      }
    }
    if (_leads != null) {
      await _leads!.patchLead(lead);
    } else {
      await _repository.updateLead(lead);
    }
  }

  Future<void> cloneLead(Lead lead) async {
    if (_leads != null) {
      await _leads!.cloneLead(lead);
    } else {
      await _repository.createLead(
        lead.copyWith(id: '', businessName: '${lead.businessName} (Copy)', source: 'Referrals'),
      );
    }
    await load();
  }

  void confirmDelete(Lead lead) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete lead?'),
        content: Text('This will remove ${lead.businessName} from referral leads.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              await _repository.deleteLead(lead.id);
              await load();
              await _leads?.load();
            },
            child: const Text('Delete', style: TextStyle(color: Color(0xFFC62828))),
          ),
        ],
      ),
    );
  }

  void callLead(Lead lead) => _leads?.callLead(lead);

  void navigateToLead(Lead lead) => _leads?.navigateToLead(lead);

  void showLeadActions(Lead lead) => _leads?.showLeadActions(lead);
}
