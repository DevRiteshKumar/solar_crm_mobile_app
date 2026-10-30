import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../data/models/lead.dart';
import '../../data/models/lead_detail.dart';
import 'lead_detail_controller.dart';
import 'lead_detail_sheets.dart';

class LeadDetailView extends GetView<LeadDetailController> {
  const LeadDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final lead = controller.lead;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: Obx(() {
        final tab = controller.tabIndex.value;
        if (tab == 0) return const SizedBox.shrink();
        return FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: Text(_fabLabel(tab)),
          onPressed: () => _openAdd(tab),
        );
      }),
      body: Column(
        children: [
          _Header(
            lead: lead,
            onCall: controller.callCustomer,
            onEdit: controller.editLead,
          ),
          Obx(
            () => _Tabs(
              selected: controller.tabIndex.value,
              counts: [
                0,
                controller.tasks.length,
                controller.notes.length,
                controller.calls.length,
                controller.files.length,
              ],
              onSelected: controller.selectTab,
            ),
          ),
          Expanded(
            child: Obx(() {
              switch (controller.tabIndex.value) {
                case 1:
                  return _TaskList(tasks: controller.tasks.toList());
                case 2:
                  return _NoteList(notes: controller.notes.toList());
                case 3:
                  return _CallList(calls: controller.calls.toList());
                case 4:
                  return _FileList(files: controller.files.toList());
                default:
                  return _InformationTab(controller: controller);
              }
            }),
          ),
        ],
      ),
    );
  }

  String _fabLabel(int tab) {
    switch (tab) {
      case 1:
        return 'Add Task';
      case 2:
        return 'Add Note';
      case 3:
        return 'Call Log';
      case 4:
        return 'Add File';
      default:
        return 'Add';
    }
  }

  void _openAdd(int tab) {
    switch (tab) {
      case 1:
        showAddTaskSheet(controller);
        break;
      case 2:
        showAddNoteSheet(controller);
        break;
      case 3:
        showAddCallSheet(controller);
        break;
      case 4:
        showAddFileSheet(controller);
        break;
    }
  }
}

class _Header extends StatelessWidget {
  final Lead lead;
  final VoidCallback onCall;
  final VoidCallback onEdit;

  const _Header({
    required this.lead,
    required this.onCall,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 8, 12),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lead.customerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.heading2.copyWith(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lead.businessName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onCall,
              style: IconButton.styleFrom(backgroundColor: AppColors.drawerActiveBg),
              icon: const Icon(Icons.call_outlined, color: AppColors.primary),
            ),
            const SizedBox(width: 4),
            TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Edit', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  final int selected;
  final List<int> counts;
  final ValueChanged<int> onSelected;

  const _Tabs({
    required this.selected,
    required this.counts,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.info_outline, 'Information'),
      (Icons.task_alt_outlined, 'Tasks'),
      (Icons.sticky_note_2_outlined, 'Notes'),
      (Icons.call_outlined, 'Calls'),
      (Icons.folder_outlined, 'Files'),
    ];
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 2),
        itemBuilder: (context, index) {
          final active = selected == index;
          final count = counts[index];
          return InkWell(
            onTap: () => onSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: active ? AppColors.primary : Colors.transparent,
                    width: 2.6,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    items[index].$1,
                    size: 16,
                    color: active ? AppColors.primary : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    items[index].$2,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: active ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                  if (index > 0 && count > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: active ? AppColors.drawerActiveBg : AppColors.chipBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: active ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InformationTab extends StatelessWidget {
  final LeadDetailController controller;

  const _InformationTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    final lead = controller.lead;
    final site = controller.site;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Lead Information',
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: controller.editLead,
                      icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.accentPurple),
                      label: const Text(
                        'Edit',
                        style: TextStyle(color: AppColors.accentPurple, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Obx(
                () => Column(
                  children: [
                    _AccordionTile(
                      title: 'Customer Information',
                      expanded: controller.isOpen('customer'),
                      onToggle: () => controller.toggleSection('customer'),
                      child: Column(
                        children: [
                          _KV('Customer Name', lead.customerName),
                          _KV('Business Name', lead.businessName),
                          _KV('Contact Number', lead.phone),
                          _KV('Town', site.town),
                          _KV('State', site.state, last: true),
                        ],
                      ),
                    ),
                    _AccordionTile(
                      title: 'Electricity Bill Details',
                      expanded: controller.isOpen('bill'),
                      onToggle: () => controller.toggleSection('bill'),
                      child: Column(
                        children: [
                          _KV('Average Monthly Units', site.monthlyUnits),
                          _KV('Average Monthly Bill', site.monthlyBill),
                          _KV('Sanctioned Load', site.sanctionedLoad),
                          _KV('Last Bill Date', site.lastBillDate, last: true),
                        ],
                      ),
                    ),
                    _AccordionTile(
                      title: 'Connection Details',
                      expanded: controller.isOpen('connection'),
                      onToggle: () => controller.toggleSection('connection'),
                      child: _KV('LT or HT Connection', site.connectionType, last: true),
                    ),
                    _AccordionTile(
                      title: 'Roof Information',
                      expanded: controller.isOpen('roof'),
                      onToggle: () => controller.toggleSection('roof'),
                      child: Column(
                        children: [
                          _KV('Roof Types', ''),
                          const SizedBox(height: 8),
                          _RoofTable(rows: site.roofs),
                        ],
                      ),
                    ),
                    _AccordionTile(
                      title: 'Solar System Size Offered',
                      expanded: controller.isOpen('solar'),
                      onToggle: () => controller.toggleSection('solar'),
                      child: _KV('Solar System Size Offered', site.solarSizeOffered, last: true),
                    ),
                    _AccordionTile(
                      title: 'DC and AC Cable Distance Calculator',
                      expanded: controller.isOpen('cable'),
                      onToggle: () => controller.toggleSection('cable'),
                      last: true,
                      child: Column(
                        children: [
                          _KV('Inverter Type', site.inverterType),
                          _KV('Average distance from Panels to the Inverter', site.panelToInverter),
                          _KV('Distance of Inverter to AC Junction Box', site.inverterToAcjb),
                          _KV('Distance from AC Junction Box to Load Termination', site.acjbToLoad, last: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AccordionTile extends StatelessWidget {
  final String title;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;
  final bool last;

  const _AccordionTile({
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.child,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ),
                Icon(
                  expanded ? Icons.expand_more : Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: child,
          ),
        if (!last) const Divider(height: 1),
      ],
    );
  }
}

class _KV extends StatelessWidget {
  final String label;
  final String value;
  final bool last;

  const _KV(this.label, this.value, {this.last = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
          ),
          Text(':  ', style: AppTextStyles.caption.copyWith(color: AppColors.textHint)),
          Expanded(
            flex: 6,
            child: Text(
              value.isEmpty ? '' : value,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoofTable extends StatelessWidget {
  final List<RoofRecord> rows;

  const _RoofTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.1),
              1: FlexColumnWidth(2.2),
              2: FlexColumnWidth(2.6),
            },
            children: const [
              TableRow(
                decoration: BoxDecoration(color: Color(0xFFF8FAFC)),
                children: [
                  _Th('SNo'),
                  _Th('Roof Types'),
                  _Th('Total Roof Area in sq feet'),
                ],
              ),
            ],
          ),
          const Divider(height: 1),
          if (rows.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No More Records',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textHint, fontWeight: FontWeight.w600),
              ),
            )
          else
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.1),
                1: FlexColumnWidth(2.2),
                2: FlexColumnWidth(2.6),
              },
              children: rows
                  .map(
                    (r) => TableRow(
                      children: [
                        _Td('${r.serial}'),
                        _Td(r.type),
                        _Td(r.areaSqFt),
                      ],
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _Th extends StatelessWidget {
  final String text;
  const _Th(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary),
      ),
    );
  }
}

class _Td extends StatelessWidget {
  final String text;
  const _Td(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(text, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
    );
  }
}

class _Empty extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _Empty({required this.icon, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.drawerActiveBg,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(height: 14),
            Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  final List<LeadTask> tasks;
  const _TaskList({required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const _Empty(
        icon: Icons.task_alt_outlined,
        title: 'No tasks yet',
        message: 'Add a follow-up, site visit or call for this lead.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final t = tasks[i];
        return _ActivityCard(
          icon: Icons.task_alt_outlined,
          title: t.title,
          subtitle: '${t.category} · ${t.responsible}',
          meta: '${t.startDate} → ${t.dueDate}',
          badge: t.status,
        );
      },
    );
  }
}

class _NoteList extends StatelessWidget {
  final List<LeadNote> notes;
  const _NoteList({required this.notes});

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const _Empty(
        icon: Icons.sticky_note_2_outlined,
        title: 'No notes yet',
        message: 'Capture discussion points and site observations here.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
      itemCount: notes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final n = notes[i];
        return _ActivityCard(
          icon: Icons.sticky_note_2_outlined,
          title: n.description,
          subtitle: n.createdAt,
        );
      },
    );
  }
}

class _CallList extends StatelessWidget {
  final List<LeadCallLog> calls;
  const _CallList({required this.calls});

  @override
  Widget build(BuildContext context) {
    if (calls.isEmpty) {
      return const _Empty(
        icon: Icons.call_outlined,
        title: 'No call logs yet',
        message: 'Log connected, busy and follow-up calls for this lead.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
      itemCount: calls.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final c = calls[i];
        return _ActivityCard(
          icon: Icons.call_outlined,
          title: c.status,
          subtitle: c.note,
          meta: 'Follow up ${c.followUpDate}',
          badge: c.createdAt,
        );
      },
    );
  }
}

class _FileList extends StatelessWidget {
  final List<LeadFileItem> files;
  const _FileList({required this.files});

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) {
      return const _Empty(
        icon: Icons.folder_outlined,
        title: 'No files yet',
        message: 'Upload quotations, site photos and documents here.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
      itemCount: files.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final f = files[i];
        return _ActivityCard(
          icon: Icons.insert_drive_file_outlined,
          title: f.title,
          subtitle: '${f.documentType} · ${f.owner}',
          meta: f.content,
        );
      },
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? meta;
  final String? badge;

  const _ActivityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.meta,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.drawerActiveBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.caption),
                if (meta != null && meta!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(meta!, style: AppTextStyles.caption.copyWith(color: AppColors.textHint)),
                ],
              ],
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badge!,
                style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }
}
