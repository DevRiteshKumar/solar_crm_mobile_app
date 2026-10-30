import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/routes/app_routes.dart';
import '../../core/utils/launch_helpers.dart';
import '../../data/models/lead.dart';
import '../../data/repositories/lead_repository.dart';
import '../dashboard/dashboard_controller.dart';
import '../lead_map/lead_map_controller.dart';

class LeadsController extends GetxController {
  final LeadRepository _repository = Get.find();

  final isLoading = false.obs;
  final leads = <Lead>[].obs;
  final allLeads = <Lead>[].obs;
  final filters = <String>['All', 'Today', 'High Priority', 'Interested'].obs;
  final customFilters = <String>[].obs;
  final selectedFilter = 'All'.obs;
  final searchQuery = ''.obs;
  final showSearch = false.obs;
  final sortLabel = 'Last Contact'.obs;
  final checkedInIds = <String>{}.obs;

  int get totalLeads => allLeads.length;
  int get dueToday => allLeads.where((l) => l.todayVisit).length;
  int get needsAttention => allLeads
      .where((l) => l.priority.toLowerCase().contains('high') || l.status == 'Interested')
      .length;
  int get thisWeek => allLeads.where((l) => l.todayVisit || l.nextStep == 'Follow up Call').length;

  String get pageTitle {
    final filter = selectedFilter.value;
    if (filter == 'All' || filter == 'All Leads') return 'Leads';
    return filter;
  }

  @override
  void onInit() {
    super.onInit();
    loadFilters();
    load();
  }

  Future<void> loadFilters() async {
    final list = await _repository.getFilters();
    if (list.isNotEmpty) filters.assignAll(list);
    customFilters.assignAll(await _repository.getCustomFilters());
  }

  Future<void> load() async {
    try {
      isLoading.value = true;
      final all = await _repository.getLeads(query: searchQuery.value);
      allLeads.assignAll(all);
      leads.assignAll(applyFilter(all, selectedFilter.value));
    } finally {
      isLoading.value = false;
    }
  }

  List<Lead> applyFilter(List<Lead> source, String filter) {
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
      if (f.contains('new very high')) {
        return l.priority.toLowerCase().contains('high') && l.todayVisit;
      }
      return false;
    }).toList();
  }

  void toggleSearch() => showSearch.toggle();

  void onSearch(String q) {
    searchQuery.value = q;
    load();
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
    leads.assignAll(applyFilter(allLeads, filter));
  }

  Future<void> deleteLead(String id) async {
    await _repository.deleteLead(id);
    await load();
    Get.snackbar('Deleted', 'Lead removed', snackPosition: SnackPosition.BOTTOM);
  }

  void editLead(Lead lead) {
    Get.toNamed(AppRoutes.leadForm, arguments: lead);
  }

  void openLeadDetail(Lead lead, {int tab = 0}) {
    Get.toNamed(AppRoutes.leadDetail, arguments: {'lead': lead, 'tab': tab});
  }

  Future<void> patchLead(Lead lead) async {
    final index = leads.indexWhere((l) => l.id == lead.id);
    if (index >= 0) leads[index] = lead;
    final allIndex = allLeads.indexWhere((l) => l.id == lead.id);
    if (allIndex >= 0) allLeads[allIndex] = lead;
    await _repository.updateLead(lead);
    if (Get.isRegistered<LeadMapController>()) {
      Get.find<LeadMapController>().replaceLead(lead);
    }
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().replaceLead(lead);
    }
  }

  Future<void> cloneLead(Lead lead) async {
    await _repository.createLead(
      lead.copyWith(
        id: '',
        businessName: '${lead.businessName} (Copy)',
      ),
    );
    await load();
    Get.snackbar('Cloned', '${lead.businessName} duplicated', snackPosition: SnackPosition.BOTTOM);
  }

  void confirmDelete(Lead lead) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete lead?'),
        content: Text('This will remove ${lead.businessName} from your pipeline.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              deleteLead(lead.id);
            },
            child: const Text('Delete', style: TextStyle(color: Color(0xFFC62828))),
          ),
        ],
      ),
    );
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

  Future<void> callLead(Lead lead) async {
    final uri = Uri(scheme: 'tel', path: LaunchHelpers.digitsOnly(lead.phone));
    await _open(uri, 'Could not open the phone dialer');
  }

  Future<void> whatsappLead(Lead lead) async {
    final number = LaunchHelpers.whatsappNumber(lead.phone);
    final message = Uri.encodeComponent('Hi ${lead.customerName}, regarding ${lead.businessName}');
    final uri = Uri.parse('https://wa.me/$number?text=$message');
    await _open(uri, 'Could not open WhatsApp');
  }

  Future<void> navigateToLead(Lead lead) async {
    final query = Uri.encodeComponent(lead.address ?? '${lead.businessName}, ${lead.customerName}');
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    await _open(uri, 'Could not open Maps');
  }

  void checkInLead(Lead lead) {
    if (checkedInIds.contains(lead.id)) {
      Get.snackbar(
        'Already checked in',
        'You already checked in at ${lead.businessName}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    checkedInIds.add(lead.id);
    Get.snackbar(
      'Checked in',
      'Checked in at ${lead.businessName}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _open(Uri uri, String errorMessage) async {
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        Get.snackbar('Error', errorMessage, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (_) {
      Get.snackbar('Error', errorMessage, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void showLeadActions(Lead lead) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit'),
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.leadForm, arguments: lead);
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone_outlined, color: Color(0xFFC62828)),
                title: const Text('Call'),
                onTap: () {
                  Get.back();
                  callLead(lead);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Color(0xFFC62828)),
                title: const Text('Delete'),
                onTap: () {
                  Get.back();
                  deleteLead(lead.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showFiltersSheet() {
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
                ...filters.map((f) => _filterTile(f)),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Text(
                    'Custom Filters',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFC62828),
                    ),
                  ),
                ),
                ...customFilters.map((f) => _filterTile(f)),
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

  void showSortOptions() {
    final options = ['Last Contact', 'Priority', 'Name', 'Status'];
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (o) => ListTile(
                    title: Text(o),
                    trailing: sortLabel.value == o
                        ? const Icon(Icons.check, color: Color(0xFFC62828))
                        : null,
                    onTap: () {
                      sortLabel.value = o;
                      Get.back();
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
