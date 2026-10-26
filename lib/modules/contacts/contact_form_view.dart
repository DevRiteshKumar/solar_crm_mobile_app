import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/pro_ui.dart';
import 'contact_form_controller.dart';

class ContactFormView extends GetView<ContactFormController> {
  const ContactFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ProPageHeader(
            title: controller.isEdit ? 'Edit Contact' : 'Add Contact',
            subtitle: 'Basic info & address',
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
                          Row(
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: AppColors.inputFill,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: const Icon(Icons.image_outlined, color: AppColors.textHint),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => Get.snackbar(
                                        'Upload',
                                        'File upload with API later',
                                        snackPosition: SnackPosition.BOTTOM,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accentPurple,
                                        minimumSize: const Size(0, 36),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('Upload File', style: TextStyle(fontSize: 13)),
                                    ),
                                    Text(
                                      'JPG, PNG, DOC or PDF. Max 800K.',
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            label: 'First Name',
                            controller: controller.firstName,
                            validator: controller.validateFirstName,
                            outlined: true,
                            required: true,
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: 'Last Name',
                            controller: controller.lastName,
                            outlined: true,
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: 'Job Title',
                            controller: controller.jobTitle,
                            outlined: true,
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: 'Company Name',
                            controller: controller.companyName,
                            outlined: true,
                            hint: 'Select Company',
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                '+ Add New',
                                style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                              ),
                            ),
                          ),
                          AppTextField(
                            label: 'Phone 1',
                            controller: controller.phone1,
                            keyboardType: TextInputType.phone,
                            validator: controller.validatePhone,
                            outlined: true,
                            required: true,
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: 'Phone 2',
                            controller: controller.phone2,
                            keyboardType: TextInputType.phone,
                            outlined: true,
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: 'Email',
                            controller: controller.email,
                            keyboardType: TextInputType.emailAddress,
                            outlined: true,
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            label: 'Industry',
                            controller: controller.industry,
                            outlined: true,
                            hint: 'Select Industry',
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                '+ Add New',
                                style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                              ),
                            ),
                          ),
                          AppTextField(
                            label: 'Description',
                            controller: controller.description,
                            outlined: true,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => _Accordion(
                      title: 'Address Info',
                      icon: Icons.location_on_outlined,
                      expanded: controller.addressExpanded.value,
                      onToggle: () => controller.addressExpanded.toggle(),
                      child: Column(
                        children: [
                          AppTextField(
                            label: 'Street Address',
                            controller: controller.street,
                            outlined: true,
                          ),
                          const SizedBox(height: 12),
                          AppTextField(label: 'City', controller: controller.city, outlined: true),
                          const SizedBox(height: 12),
                          AppTextField(label: 'State', controller: controller.state, outlined: true),
                          const SizedBox(height: 12),
                          AppTextField(label: 'Country', controller: controller.country, outlined: true),
                          const SizedBox(height: 12),
                          AppTextField(label: 'Zipcode', controller: controller.zipcode, outlined: true),
                        ],
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
                            label: controller.isEdit ? 'Update' : 'Create',
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
                  Expanded(child: Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700))),
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
