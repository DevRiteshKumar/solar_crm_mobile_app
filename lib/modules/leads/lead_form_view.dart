import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/lead_field_dropdowns.dart';
import '../../core/widgets/pro_ui.dart';
import '../../data/models/lead.dart';
import 'lead_form_controller.dart';

class LeadFormView extends GetView<LeadFormController> {
  const LeadFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ProPageHeader(
            title: controller.isEdit ? 'Edit Lead' : 'Add Lead',
            subtitle: controller.isEdit ? 'Update lead details' : 'Create a new pipeline lead',
            showBack: true,
          ),
          Expanded(
            child: Form(
              key: controller.formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Obx(
                    () => _Accordion(
                      title: 'Basic Info',
                      icon: Icons.person_outline,
                      expanded: controller.basicExpanded.value,
                      onToggle: () => controller.basicExpanded.toggle(),
                      child: Column(
                        children: [
                          AppTextField(
                            label: 'Customer Name',
                            controller: controller.customerName,
                            validator: controller.validateCustomer,
                            outlined: true,
                            required: true,
                            hint: 'e.g. Geetha',
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: 'Business Name',
                            controller: controller.businessName,
                            validator: controller.validateBusiness,
                            outlined: true,
                            required: true,
                            hint: 'e.g. Geetha School',
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: 'Phone',
                            controller: controller.phone,
                            keyboardType: TextInputType.phone,
                            validator: controller.validatePhone,
                            outlined: true,
                            required: true,
                            hint: '+91 98765 43210',
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: 'Email',
                            controller: controller.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: controller.validateEmail,
                            outlined: true,
                            hint: 'optional',
                          ),
                          const SizedBox(height: 14),
                          _ChipPicker(
                            label: 'Lead Type',
                            options: LeadFormController.leadTypes,
                            selected: controller.leadType.value,
                            onSelected: (v) => controller.leadType.value = v,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => _Accordion(
                      title: 'Lead Details',
                      icon: Icons.flag_outlined,
                      expanded: controller.detailsExpanded.value,
                      onToggle: () => controller.detailsExpanded.toggle(),
                      child: Column(
                        children: [
                          LeadFieldDropdowns(
                            compact: false,
                            lead: Lead(
                              id: controller.editing?.id ?? '',
                              customerName: controller.customerName.text,
                              businessName: controller.businessName.text,
                              phone: controller.phone.text,
                              leadType: controller.leadType.value,
                              status: controller.status.value,
                              priority: controller.priority.value,
                              source: controller.source.value,
                              nextStep: controller.nextStepValue.value,
                            ),
                            onChanged: (lead) {
                              controller.status.value = lead.status;
                              controller.priority.value = lead.priority;
                              controller.source.value = lead.source;
                              controller.nextStepValue.value = lead.nextStep ?? '';
                            },
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: 'Estimated Value (₹)',
                            controller: controller.price,
                            keyboardType: TextInputType.number,
                            outlined: true,
                            hint: 'e.g. 250000',
                          ),
                          const SizedBox(height: 8),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Today’s visit',
                              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              'Mark if you plan to visit today',
                              style: AppTextStyles.caption,
                            ),
                            activeColor: AppColors.primary,
                            value: controller.todayVisit.value,
                            onChanged: (v) => controller.todayVisit.value = v,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => _Accordion(
                      title: 'Address',
                      icon: Icons.location_on_outlined,
                      expanded: controller.addressExpanded.value,
                      onToggle: () => controller.addressExpanded.toggle(),
                      child: AppTextField(
                        label: 'Address',
                        controller: controller.address,
                        outlined: true,
                        maxLines: 3,
                        hint: 'Street, city, state',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Cancel',
                          outlined: true,
                          onPressed: () => Get.back(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(
                          () => AppButton(
                            label: controller.isEdit ? 'Update Lead' : 'Create Lead',
                            isLoading: controller.isLoading.value,
                            onPressed: controller.save,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Accordion extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;

  const _Accordion({
    required this.title,
    required this.icon,
    required this.expanded,
    required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ProListCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Icon(expanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
              child: child,
            ),
        ],
      ),
    );
  }
}

class _ChipPicker extends StatelessWidget {
  final String label;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const _ChipPicker({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = option == selected;
            return GestureDetector(
              onTap: () => onSelected(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
