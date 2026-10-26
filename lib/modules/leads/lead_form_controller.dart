import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/validators.dart';
import '../../data/models/lead.dart';
import '../../data/repositories/lead_repository.dart';
import '../dashboard/dashboard_controller.dart';
import '../lead_map/lead_map_controller.dart';
import 'leads_controller.dart';

class LeadFormController extends GetxController {
  final LeadRepository _repository = Get.find();

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final basicExpanded = true.obs;
  final detailsExpanded = true.obs;
  final addressExpanded = true.obs;

  Lead? editing;

  final customerName = TextEditingController();
  final businessName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final nextStep = TextEditingController();
  final price = TextEditingController();
  final address = TextEditingController();

  final leadType = 'Residential'.obs;
  final status = 'Interested'.obs;
  final priority = 'Medium'.obs;
  final todayVisit = false.obs;

  static const leadTypes = ['Residential', 'Commercial', 'Industrial'];
  static const statuses = ['Interested', 'Qualified', 'Quotation Sent', 'Deal Confirmed'];
  static const priorities = ['High', 'Medium', 'Low'];

  bool get isEdit => editing != null;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is Lead) {
      editing = arg;
      customerName.text = arg.customerName;
      businessName.text = arg.businessName;
      phone.text = arg.phone;
      email.text = arg.email ?? '';
      nextStep.text = arg.nextStep ?? '';
      price.text = arg.price != null ? arg.price!.toStringAsFixed(0) : '';
      address.text = arg.address ?? '';
      leadType.value = arg.leadType.isNotEmpty ? arg.leadType : 'Residential';
      status.value = arg.status;
      priority.value = arg.priority;
      todayVisit.value = arg.todayVisit;
    }
  }

  Future<void> save() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    try {
      isLoading.value = true;
      final parsedPrice = double.tryParse(price.text.trim());
      final lead = Lead(
        id: editing?.id ?? '',
        customerName: customerName.text.trim(),
        businessName: businessName.text.trim(),
        phone: phone.text.trim(),
        email: email.text.trim().isEmpty ? null : email.text.trim(),
        leadType: leadType.value,
        status: status.value,
        priority: priority.value,
        nextStep: nextStep.text.trim().isEmpty ? null : nextStep.text.trim(),
        price: parsedPrice,
        lastContact: editing?.lastContact,
        address: address.text.trim().isEmpty ? null : address.text.trim(),
        latitude: editing?.latitude,
        longitude: editing?.longitude,
        todayVisit: todayVisit.value,
        tags: editing?.tags ?? const [],
      );

      if (isEdit) {
        await _repository.updateLead(lead);
      } else {
        await _repository.createLead(lead);
      }

      if (Get.isRegistered<LeadsController>()) {
        await Get.find<LeadsController>().load();
      }
      if (Get.isRegistered<DashboardController>()) {
        await Get.find<DashboardController>().load();
      }
      if (Get.isRegistered<LeadMapController>()) {
        await Get.find<LeadMapController>().load();
      }

      Get.back();
      Get.snackbar(
        'Success',
        isEdit ? 'Lead updated' : 'Lead created',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? validateCustomer(String? v) => Validators.required(v, 'Customer name');
  String? validateBusiness(String? v) => Validators.required(v, 'Business name');
  String? validatePhone(String? v) => Validators.phone(v);

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final regex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,}$');
    if (!regex.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  @override
  void onClose() {
    customerName.dispose();
    businessName.dispose();
    phone.dispose();
    email.dispose();
    nextStep.dispose();
    price.dispose();
    address.dispose();
    super.onClose();
  }
}
