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
  final allLeads = <Lead>[].obs;
  final searchQuery = ''.obs;
  final showSearch = false.obs;
  final sortLabel = 'Last Contact'.obs;
  final selectedFilter = 'All'.obs;

  int get totalLeads => allLeads.length;
  int get dueToday => allLeads.where((l) => l.todayVisit).length;
  int get needsAttention => allLeads
      .where((l) => l.priority.toLowerCase().contains('high') || l.status == 'Interested')
      .length;
  int get thisWeek => allLeads.where((l) => l.todayVisit || l.nextStep == 'Follow up Call').length;

  List<String> get customFilters => _leads?.customFilters.toList() ?? const [];

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
      final all = await _repository.getLeads(
        query: searchQuery.value,
        filter: 'Referral Leads',
      );
      allLeads.assignAll(all);
      leads.assignAll(_applyFilter(all, selectedFilter.value));
    } finally {
      isLoading.value = false;
    }
  }

  List<Lead> _applyFilter(List<Lead> source, String filter) {
    if (_leads != null) return _leads!.applyFilter(source, filter);
    if (filter.isEmpty || filter == 'All' || filter == 'All Leads') return source;
    final f = filter.toLowerCase();
    return source.where((l) {
      if (l.tags.any((t) => t.toLowerCase() == f)) return true;
      if (f == 'today') return l.todayVisit;
      if (f == 'high priority' || f == 'very high priority') {
        return l.priority.toLowerCase().contains('high');
      }
      if (f == 'interested' || f == 'intrested') {
        return l.status.toLowerCase() == 'interested';
      }
      return false;
    }).toList();
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
    leads.assignAll(_applyFilter(allLeads, filter));
  }

  void showFiltersSheet() {
    final basics = ['All', 'Today', 'High Priority', 'Interested'];
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 8),
                ...basics.map(_filterTile),
                if (customFilters.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text(
                      'Custom Filters',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFFC62828)),
                    ),
                  ),
                  ...customFilters.map(_filterTile),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterTile(String f) {
    return ListTile(
      dense: true,
      title: Text(f),
      trailing: selectedFilter.value == f
          ? const Icon(Icons.check, color: Color(0xFFC62828))
          : null,
      onTap: () {
        selectFilter(f);
        Get.back();
      },
    );
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
