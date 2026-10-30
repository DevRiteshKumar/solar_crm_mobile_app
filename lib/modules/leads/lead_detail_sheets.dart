import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../data/models/lead_detail.dart';
import 'lead_detail_controller.dart';

void showAddTaskSheet(LeadDetailController controller) {
  Get.bottomSheet(
    _AddTaskSheet(controller: controller),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

void showAddNoteSheet(LeadDetailController controller) {
  Get.bottomSheet(
    _AddNoteSheet(controller: controller),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

void showAddCallSheet(LeadDetailController controller) {
  Get.bottomSheet(
    _AddCallSheet(controller: controller),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

void showAddFileSheet(LeadDetailController controller) {
  Get.bottomSheet(
    _AddFileSheet(controller: controller),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

class _SheetScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget> actions;

  const _SheetScaffold({
    required this.title,
    required this.child,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.88,
        child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: child,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(children: actions),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class _AddTaskSheet extends StatefulWidget {
  final LeadDetailController controller;

  const _AddTaskSheet({required this.controller});

  @override
  State<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<_AddTaskSheet> {
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final responsible = TextEditingController();
  final description = TextEditingController();
  final startDate = TextEditingController();
  final dueDate = TextEditingController();
  final time = TextEditingController();
  final reminder = TextEditingController();
  String category = 'Follow Up';
  String priority = 'Medium';
  String status = 'New';

  @override
  void dispose() {
    title.dispose();
    responsible.dispose();
    description.dispose();
    startDate.dispose();
    dueDate.dispose();
    time.dispose();
    reminder.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController field) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      field.text = DateFormat('dd MMM yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      title: 'Add Task',
      actions: [
        Expanded(
          child: AppButton(label: 'Cancel', outlined: true, onPressed: () => Get.back()),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppButton(
            label: 'Save Task',
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) return;
              widget.controller.addTask(
                LeadTask(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: title.text.trim(),
                  category: category,
                  responsible: responsible.text.trim(),
                  startDate: startDate.text.trim(),
                  dueDate: dueDate.text.trim(),
                  time: time.text.trim(),
                  reminder: reminder.text.trim(),
                  priority: priority,
                  status: status,
                  description: description.text.trim(),
                ),
              );
              Get.back();
            },
          ),
        ),
      ],
      child: Form(
        key: formKey,
        child: Column(
          children: [
            AppTextField(label: 'Title', controller: title, required: true, outlined: true, validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null),
            const SizedBox(height: 12),
            _DropdownField(
              label: 'Category',
              value: category,
              items: const ['Follow Up', 'Site Visit', 'Call', 'Documentation'],
              onChanged: (v) => setState(() => category = v),
            ),
            const SizedBox(height: 12),
            AppTextField(label: 'Responsible Persons', controller: responsible, required: true, outlined: true, validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Start Date',
                    controller: startDate,
                    required: true,
                    outlined: true,
                    suffixIcon: IconButton(icon: const Icon(Icons.calendar_today_outlined, size: 18), onPressed: () => _pickDate(startDate)),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppTextField(
                    label: 'Due Date',
                    controller: dueDate,
                    required: true,
                    outlined: true,
                    suffixIcon: IconButton(icon: const Icon(Icons.calendar_today_outlined, size: 18), onPressed: () => _pickDate(dueDate)),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: AppTextField(label: 'Time of Task', controller: time, required: true, outlined: true, hint: '10:30 AM')),
                const SizedBox(width: 10),
                Expanded(child: AppTextField(label: 'Set Remainder', controller: reminder, required: true, outlined: true, hint: '30 min before')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _DropdownField(label: 'Priority', value: priority, items: const ['High', 'Medium', 'Low'], onChanged: (v) => setState(() => priority = v)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DropdownField(label: 'Status', value: status, items: const ['New', 'In Progress', 'Completed'], onChanged: (v) => setState(() => status = v)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppTextField(label: 'Description', controller: description, required: true, outlined: true, maxLines: 4, validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
          ],
        ),
      ),
    );
  }
}

class _AddNoteSheet extends StatefulWidget {
  final LeadDetailController controller;
  const _AddNoteSheet({required this.controller});

  @override
  State<_AddNoteSheet> createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends State<_AddNoteSheet> {
  final formKey = GlobalKey<FormState>();
  final description = TextEditingController();

  @override
  void dispose() {
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      title: 'Add New Notes',
      actions: [
        Expanded(child: AppButton(label: 'Cancel', outlined: true, onPressed: () => Get.back())),
        const SizedBox(width: 12),
        Expanded(
          child: AppButton(
            label: 'Confirm',
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) return;
              widget.controller.addNote(
                LeadNote(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  description: description.text.trim(),
                  createdAt: DateFormat('dd MMM yyyy').format(DateTime.now()),
                ),
              );
              Get.back();
            },
          ),
        ),
      ],
      child: Form(
        key: formKey,
        child: Column(
          children: [
            AppTextField(
              label: 'Description',
              controller: description,
              required: true,
              outlined: true,
              maxLines: 5,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Description is required' : null,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                ),
                child: Column(
                  children: [
                    Icon(Icons.upload_file_outlined, color: AppColors.accentPurple),
                    const SizedBox(height: 6),
                    Text('Upload File', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accentPurple, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddCallSheet extends StatefulWidget {
  final LeadDetailController controller;
  const _AddCallSheet({required this.controller});

  @override
  State<_AddCallSheet> createState() => _AddCallSheetState();
}

class _AddCallSheetState extends State<_AddCallSheet> {
  final formKey = GlobalKey<FormState>();
  final followUp = TextEditingController();
  final note = TextEditingController();
  String status = 'Connected';

  @override
  void dispose() {
    followUp.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      title: 'Create Call Log',
      actions: [
        Expanded(child: AppButton(label: 'Cancel', outlined: true, onPressed: () => Get.back())),
        const SizedBox(width: 12),
        Expanded(
          child: AppButton(
            label: 'Confirm',
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) return;
              widget.controller.addCall(
                LeadCallLog(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  status: status,
                  followUpDate: followUp.text.trim(),
                  note: note.text.trim(),
                  createdAt: DateFormat('dd MMM yyyy').format(DateTime.now()),
                ),
              );
              Get.back();
            },
          ),
        ),
      ],
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _DropdownField(
              label: 'Status',
              requiredField: true,
              value: status,
              items: const ['Connected', 'Wrong Number', 'Not Reachable', 'Busy', 'Call Back'],
              onChanged: (v) => setState(() => status = v),
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Follow Up Date',
              controller: followUp,
              required: true,
              outlined: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today_outlined, size: 18),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) followUp.text = DateFormat('dd MMM yyyy').format(picked);
                },
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Note',
              controller: note,
              required: true,
              outlined: true,
              maxLines: 4,
              hint: 'Add text',
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddFileSheet extends StatefulWidget {
  final LeadDetailController controller;
  const _AddFileSheet({required this.controller});

  @override
  State<_AddFileSheet> createState() => _AddFileSheetState();
}

class _AddFileSheetState extends State<_AddFileSheet> {
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final content = TextEditingController();
  String documentType = 'Quotation';
  String owner = 'Sales Team';

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      title: 'Add New Files',
      actions: [
        Expanded(child: AppButton(label: 'Submit', onPressed: () {
          if (!(formKey.currentState?.validate() ?? false)) return;
          widget.controller.addFile(
            LeadFileItem(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              documentType: documentType,
              owner: owner,
              title: title.text.trim(),
              content: content.text.trim(),
            ),
          );
          Get.back();
        })),
      ],
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _DropdownField(
                    label: 'Document Type',
                    requiredField: true,
                    value: documentType,
                    items: const ['Quotation', 'Site Photo', 'ID Proof', 'Other'],
                    onChanged: (v) => setState(() => documentType = v),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DropdownField(
                    label: 'Owner',
                    requiredField: true,
                    value: owner,
                    items: const ['Sales Team', 'Shreesha Hegde', 'Vruddi'],
                    onChanged: (v) => setState(() => owner = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppTextField(label: 'Title', controller: title, required: true, outlined: true, validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Icon(Icons.upload_file_outlined, color: AppColors.accentPurple),
                  const SizedBox(height: 6),
                  Text('Upload File', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.accentPurple, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppTextField(label: 'Content', controller: content, required: true, outlined: true, maxLines: 3, hint: 'Add Content', validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
          ],
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final bool requiredField;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.requiredField = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTextStyles.label),
            if (requiredField) const Text(' *', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
            color: AppColors.surface,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}
