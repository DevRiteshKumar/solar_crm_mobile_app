import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/routes/app_routes.dart';
import '../../core/utils/launch_helpers.dart';
import '../../data/models/contact.dart';
import '../../data/repositories/contact_repository.dart';

class ContactsController extends GetxController {
  final ContactRepository _repository = Get.find();

  final isLoading = false.obs;
  final contacts = <Contact>[].obs;
  final showSearch = false.obs;
  final selectedFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void toggleSearch() => showSearch.toggle();

  void selectFilter(String f) {
    selectedFilter.value = f;
    load();
  }

  Future<void> load({String? query}) async {
    try {
      isLoading.value = true;
      var list = await _repository.getContacts(query: query);
      if (selectedFilter.value == 'With Email') {
        list = list.where((c) => c.email != null && c.email!.isNotEmpty).toList();
      }
      contacts.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String q) => load(query: q);

  void openAdd() => Get.toNamed(AppRoutes.contactForm);

  void openEdit(Contact contact) {
    Get.toNamed(AppRoutes.contactForm, arguments: contact);
  }

  Future<void> deleteContact(String id) async {
    await _repository.deleteContact(id);
    await load();
    Get.snackbar('Deleted', 'Contact removed', snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> callContact(Contact contact) async {
    final uri = Uri(scheme: 'tel', path: LaunchHelpers.digitsOnly(contact.phone1));
    await _open(uri, 'Could not open the phone dialer');
  }

  Future<void> whatsappContact(Contact contact) async {
    final number = LaunchHelpers.whatsappNumber(contact.phone1);
    final message = Uri.encodeComponent('Hi ${contact.fullName}');
    final uri = Uri.parse('https://wa.me/$number?text=$message');
    await _open(uri, 'Could not open WhatsApp');
  }

  Future<void> emailContact(Contact contact) async {
    if (contact.email == null || contact.email!.isEmpty) {
      Get.snackbar('Email', 'No email on this contact', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final uri = Uri(scheme: 'mailto', path: contact.email);
    await _open(uri, 'Could not open email');
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

  void showContactActions(Contact contact) {
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
                  openEdit(contact);
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone_outlined, color: Color(0xFFC62828)),
                title: const Text('Call'),
                onTap: () {
                  Get.back();
                  callContact(contact);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Color(0xFFC62828)),
                title: const Text('Delete'),
                onTap: () {
                  Get.back();
                  deleteContact(contact.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
