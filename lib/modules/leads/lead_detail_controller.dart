import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/routes/app_routes.dart';
import '../../data/models/lead.dart';
import '../../data/models/lead_detail.dart';
import 'leads_controller.dart';

class LeadDetailController extends GetxController {
  late Lead lead;
  final tabIndex = 0.obs;
  final expanded = <String>{'customer'}.obs;

  final tasks = <LeadTask>[].obs;
  final notes = <LeadNote>[].obs;
  final calls = <LeadCallLog>[].obs;
  final files = <LeadFileItem>[].obs;
  late LeadSiteInfo site;

  static const tabs = ['Information', 'Tasks', 'Notes', 'Calls', 'Files'];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Lead) {
      lead = args;
    } else if (args is Map) {
      lead = args['lead'] as Lead;
      tabIndex.value = (args['tab'] as int?) ?? 0;
    } else {
      lead = const Lead(
        id: '',
        customerName: 'Lead',
        businessName: '',
        phone: '',
        leadType: '',
        status: '',
        priority: '',
      );
    }
    site = _siteFrom(lead);
    _seed(lead);
  }

  void selectTab(int index) => tabIndex.value = index;

  void toggleSection(String key) {
    if (expanded.contains(key)) {
      expanded.remove(key);
    } else {
      expanded.add(key);
    }
    expanded.refresh();
  }

  bool isOpen(String key) => expanded.contains(key);

  void editLead() => Get.toNamed(AppRoutes.leadForm, arguments: lead);

  void addTask(LeadTask task) => tasks.insert(0, task);

  void addNote(LeadNote note) => notes.insert(0, note);

  void addCall(LeadCallLog call) => calls.insert(0, call);

  void addFile(LeadFileItem file) => files.insert(0, file);

  void callCustomer() {
    if (Get.isRegistered<LeadsController>()) {
      Get.find<LeadsController>().callLead(lead);
    }
  }

  LeadSiteInfo _siteFrom(Lead lead) {
    final parts = (lead.address ?? '')
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    final state = parts.isNotEmpty ? parts.last : 'Karnataka';
    final town = parts.length >= 2 ? parts[parts.length - 2] : (parts.isNotEmpty ? parts.first : '—');

    final hasBill = lead.price != null;
    final hasAddress = (lead.address ?? '').trim().isNotEmpty;
    return LeadSiteInfo(
      town: town,
      state: state,
      monthlyUnits: hasBill ? '${(lead.price! / 20).round()} units' : '',
      monthlyBill: hasBill ? '₹${(lead.price! / 100).round()}' : '',
      sanctionedLoad: hasBill ? '${(lead.price! / 50000).clamp(1, 50).toStringAsFixed(0)} kW' : '',
      lastBillDate: lead.lastContact ?? '',
      connectionType: lead.leadType.toLowerCase().contains('industrial')
          ? 'HT'
          : (lead.leadType.isNotEmpty ? 'LT' : ''),
      solarSizeOffered: hasBill ? '${(lead.price! / 50000).clamp(2, 40).toStringAsFixed(1)} kW' : '',
      inverterType: hasBill ? 'String Inverter' : '',
      panelToInverter: lead.hasLocation ? '18 m' : '',
      inverterToAcjb: lead.hasLocation ? '8 m' : '',
      acjbToLoad: lead.hasLocation ? '12 m' : '',
      roofs: hasAddress
          ? const [
              RoofRecord(serial: 1, type: 'RCC / Concrete', areaSqFt: '1,240'),
            ]
          : const [],
    );
  }

  void _seed(Lead lead) {
    final date = DateFormat('dd MMM yyyy').format(DateTime.now());
    if (lead.nextStep != null && lead.nextStep!.isNotEmpty) {
      tasks.add(
        LeadTask(
          id: 't1',
          title: lead.nextStep!,
          category: 'Follow Up',
          responsible: 'Sales Team',
          startDate: date,
          dueDate: date,
          time: '10:30 AM',
          reminder: '30 min before',
          priority: lead.priority,
          status: lead.nextStep == 'Completed' ? 'Completed' : 'New',
          description: 'Next step for ${lead.customerName}',
        ),
      );
    }
    notes.add(
      LeadNote(
        id: 'n1',
        description: '${lead.businessName} is ${lead.status.toLowerCase()}. Priority: ${lead.priority}.',
        createdAt: lead.lastContact ?? date,
      ),
    );
    if (lead.lastContact != null) {
      calls.add(
        LeadCallLog(
          id: 'c1',
          status: 'Connected',
          followUpDate: lead.lastContact!,
          note: 'Spoke with ${lead.customerName} regarding the proposal.',
          createdAt: lead.lastContact!,
        ),
      );
    }
    if (lead.status.contains('Quotation') || lead.status.contains('Deal')) {
      files.add(
        LeadFileItem(
          id: 'f1',
          documentType: 'Quotation',
          owner: 'Sales Team',
          title: '${lead.businessName} quotation',
          content: 'Latest commercial offer',
        ),
      );
    }
  }
}
