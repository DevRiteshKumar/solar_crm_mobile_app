import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/models/lead.dart';
import '../../modules/leads/lead_options_controller.dart';

class LeadFieldDropdowns extends StatelessWidget {
  final Lead lead;
  final ValueChanged<Lead> onChanged;
  final bool compact;

  const LeadFieldDropdowns({
    super.key,
    required this.lead,
    required this.onChanged,
    this.compact = true,
  });

  LeadOptionsController get _options {
    if (!Get.isRegistered<LeadOptionsController>()) {
      Get.put(LeadOptionsController(), permanent: true);
    }
    return Get.find<LeadOptionsController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final options = _options;
      final fields = [
        _FieldSpec(
          label: 'Priority',
          value: lead.priority,
          options: options.priorities(lead.priority),
          color: const Color(0xFFFF8A00),
          onAdd: options.addPriority,
          onSelect: (v) => onChanged(lead.copyWith(priority: v)),
        ),
        _FieldSpec(
          label: 'Source',
          value: lead.source,
          options: options.sources(lead.source),
          color: const Color(0xFF7E57C2),
          onAdd: options.addSource,
          onSelect: (v) => onChanged(lead.copyWith(source: v)),
        ),
        _FieldSpec(
          label: 'Status',
          value: lead.status,
          options: options.statuses(lead.status),
          color: const Color(0xFF42A5F5),
          onAdd: options.addStatus,
          onSelect: (v) => onChanged(lead.copyWith(status: v)),
        ),
        _FieldSpec(
          label: 'Next Step',
          value: lead.nextStep ?? '',
          options: options.nextSteps(lead.nextStep),
          color: const Color(0xFF26A69A),
          onAdd: options.addNextStep,
          onSelect: (v) => onChanged(lead.copyWith(nextStep: v)),
        ),
      ];

      if (!compact) {
        return Column(
          children: [
            for (var i = 0; i < fields.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              _FormSelect(spec: fields[i]),
            ],
          ],
        );
      }

      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _MiniSelect(spec: fields[0])),
              const SizedBox(width: 7),
              Expanded(child: _MiniSelect(spec: fields[1])),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Expanded(child: _MiniSelect(spec: fields[2])),
              const SizedBox(width: 7),
              Expanded(child: _MiniSelect(spec: fields[3])),
            ],
          ),
        ],
      );
    });
  }
}

class _FieldSpec {
  final String label;
  final String value;
  final List<String> options;
  final Color color;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onAdd;

  const _FieldSpec({
    required this.label,
    required this.value,
    required this.options,
    required this.color,
    required this.onSelect,
    required this.onAdd,
  });
}

class _MiniSelect extends StatelessWidget {
  final _FieldSpec spec;

  const _MiniSelect({required this.spec});

  @override
  Widget build(BuildContext context) {
    final selected = spec.value.trim().isEmpty ? 'Select' : spec.value;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showLeadOptionSheet(spec),
        borderRadius: BorderRadius.circular(11),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(9, 6, 5, 6),
          decoration: BoxDecoration(
            color: spec.color.withValues(alpha: 0.11),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                spec.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: spec.color,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selected,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: spec.value.trim().isEmpty ? AppColors.textHint : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded, size: 15, color: spec.color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormSelect extends StatelessWidget {
  final _FieldSpec spec;

  const _FormSelect({required this.spec});

  @override
  Widget build(BuildContext context) {
    final selected = spec.value.trim().isEmpty ? 'Select' : spec.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(spec.label, style: AppTextStyles.label)),
            TextButton.icon(
              onPressed: () => _promptAddNew(spec),
              icon: const Icon(Icons.add_circle_outline, size: 16, color: AppColors.accentPurple),
              label: const Text(
                'Add New',
                style: TextStyle(color: AppColors.accentPurple, fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ),
          ],
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showLeadOptionSheet(spec),
            borderRadius: BorderRadius.circular(12),
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selected,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: spec.value.trim().isEmpty ? AppColors.textHint : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const Icon(Icons.expand_more, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void _showLeadOptionSheet(_FieldSpec spec) {
  Get.bottomSheet(
    SafeArea(
      child: Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.72),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                      spec.label,
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _promptAddNew(spec),
                    icon: const Icon(Icons.add_circle_outline, size: 16, color: AppColors.accentPurple),
                    label: const Text(
                      'Add New',
                      style: TextStyle(color: AppColors.accentPurple, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                itemCount: spec.options.length,
                separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (context, index) {
                  final option = spec.options[index];
                  final selected = option.toLowerCase() == spec.value.toLowerCase();
                  return ListTile(
                    title: Text(
                      option,
                      style: TextStyle(
                        fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                        color: selected ? spec.color : AppColors.textPrimary,
                      ),
                    ),
                    trailing: selected ? Icon(Icons.check_rounded, color: spec.color) : null,
                    onTap: () {
                      spec.onSelect(option);
                      Get.back();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

Future<void> _promptAddNew(_FieldSpec spec) async {
  final controller = TextEditingController();
  final value = await Get.dialog<String>(
    AlertDialog(
      title: Text('Add New ${spec.label}'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Enter ${spec.label.toLowerCase()}',
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (v) => Get.back(result: v.trim()),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        TextButton(
          onPressed: () => Get.back(result: controller.text.trim()),
          child: const Text('Add', style: TextStyle(fontWeight: FontWeight.w800)),
        ),
      ],
    ),
  );
  controller.dispose();
  if (value == null || value.isEmpty) return;
  spec.onAdd(value);
  spec.onSelect(value);
  if (Get.isBottomSheetOpen ?? false) Get.back();
}
