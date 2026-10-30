import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../core/widgets/contact_list_card.dart';
import '../../core/widgets/contact_summary_bar.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/widgets/pro_ui.dart';
import '../shell/shell_controller.dart';
import 'contacts_controller.dart';

class ContactsView extends GetView<ContactsController> {
  const ContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Obx(
            () => ProPageHeader(
              title: 'Contacts',
              subtitle: '${controller.totalContacts} total',
              onMenu: () => Get.find<ShellController>().openDrawer(),
              onSearch: controller.toggleSearch,
              onAdd: controller.openAdd,
            ),
          ),
          Obx(() {
            if (!controller.showSearch.value) return const SizedBox.shrink();
            return ProSearchOverlay(
              hint: 'Search contacts...',
              onChanged: controller.onSearch,
              onClose: () {
                controller.showSearch.value = false;
                controller.onSearch('');
              },
            );
          }),
          Obx(
            () => ContactSummaryBar(
              totalContacts: controller.totalContacts,
              withCompany: controller.withCompany,
              withEmail: controller.withEmail,
              selectedFilter: controller.selectedFilter.value,
              onFilterSelected: controller.selectFilter,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const LoadingView();
              if (controller.contacts.isEmpty) return const EmptyState();
              return RefreshIndicator(
                onRefresh: () => controller.load(),
                color: AppColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 108),
                  itemCount: controller.contacts.length,
                  itemBuilder: (context, index) {
                    final c = controller.contacts[index];
                    return ContactListCard(
                      contact: c,
                      onTap: () => controller.openEdit(c),
                      onMore: () => controller.showContactActions(c),
                      onCall: () => controller.callContact(c),
                      onWhatsApp: () => controller.whatsappContact(c),
                      onEmail: () => controller.emailContact(c),
                      onEdit: () => controller.openEdit(c),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
