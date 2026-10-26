import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/validators.dart';
import '../../data/models/contact.dart';
import '../../data/repositories/contact_repository.dart';
import 'contacts_controller.dart';

class ContactFormController extends GetxController {
  final ContactRepository _repository = Get.find();

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final basicExpanded = true.obs;
  final addressExpanded = true.obs;

  Contact? editing;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final jobTitle = TextEditingController();
  final companyName = TextEditingController();
  final phone1 = TextEditingController();
  final phone2 = TextEditingController();
  final email = TextEditingController();
  final industry = TextEditingController();
  final description = TextEditingController();
  final street = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController(text: 'India');
  final zipcode = TextEditingController();

  bool get isEdit => editing != null;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is Contact) {
      editing = arg;
      firstName.text = arg.firstName;
      lastName.text = arg.lastName;
      jobTitle.text = arg.jobTitle ?? '';
      companyName.text = arg.companyName ?? '';
      phone1.text = arg.phone1;
      phone2.text = arg.phone2 ?? '';
      email.text = arg.email ?? '';
      industry.text = arg.industry ?? '';
      description.text = arg.description ?? '';
      street.text = arg.streetAddress ?? '';
      city.text = arg.city ?? '';
      state.text = arg.state ?? '';
      country.text = arg.country ?? 'India';
      zipcode.text = arg.zipcode ?? '';
    }
  }

  Future<void> save() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    try {
      isLoading.value = true;
      final contact = Contact(
        id: editing?.id ?? '',
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        jobTitle: jobTitle.text.trim().isEmpty ? null : jobTitle.text.trim(),
        companyName: companyName.text.trim().isEmpty ? null : companyName.text.trim(),
        phone1: phone1.text.trim(),
        phone2: phone2.text.trim().isEmpty ? null : phone2.text.trim(),
        email: email.text.trim().isEmpty ? null : email.text.trim(),
        industry: industry.text.trim().isEmpty ? null : industry.text.trim(),
        description: description.text.trim().isEmpty ? null : description.text.trim(),
        streetAddress: street.text.trim().isEmpty ? null : street.text.trim(),
        city: city.text.trim().isEmpty ? null : city.text.trim(),
        state: state.text.trim().isEmpty ? null : state.text.trim(),
        country: country.text.trim().isEmpty ? null : country.text.trim(),
        zipcode: zipcode.text.trim().isEmpty ? null : zipcode.text.trim(),
      );

      if (isEdit) {
        await _repository.updateContact(contact);
      } else {
        await _repository.createContact(contact);
      }

      if (Get.isRegistered<ContactsController>()) {
        await Get.find<ContactsController>().load();
      }
      Get.back();
      Get.snackbar(
        'Success',
        isEdit ? 'Contact updated' : 'Contact created',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String? validateFirstName(String? v) => Validators.required(v, 'First Name');
  String? validatePhone(String? v) => Validators.phone(v);

  @override
  void onClose() {
    firstName.dispose();
    lastName.dispose();
    jobTitle.dispose();
    companyName.dispose();
    phone1.dispose();
    phone2.dispose();
    email.dispose();
    industry.dispose();
    description.dispose();
    street.dispose();
    city.dispose();
    state.dispose();
    country.dispose();
    zipcode.dispose();
    super.onClose();
  }
}
