import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/lead_pin_style.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/lead_list_card.dart';
import '../../core/widgets/loading_view.dart';
import '../../core/widgets/pro_ui.dart';
import 'lead_map_controller.dart';

class LeadMapView extends GetView<LeadMapController> {
  const LeadMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ProPageHeader(
            title: 'Lead Map',
            showBack: true,
            onSearch: () => Get.snackbar('Search', 'Map search coming soon', snackPosition: SnackPosition.BOTTOM),
            onFilter: controller.fitBounds,
            onAdd: () => Get.toNamed(AppRoutes.leadForm),
          ),
          const SizedBox(height: 8),
          Obx(() {
            return SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _CountChip(
                    label: 'All Leads',
                    count: controller.allLeads.length,
                    selected: controller.selectedFilter.value == 'All Leads',
                    color: AppColors.primary,
                    onTap: () => controller.selectFilter('All Leads'),
                  ),
                  const SizedBox(width: 8),
                  _CountChip(
                    label: 'High Priority',
                    count: controller.highPriorityCount,
                    selected: controller.selectedFilter.value == 'High Priority',
                    color: AppColors.primary,
                    onTap: () => controller.selectFilter('High Priority'),
                  ),
                  const SizedBox(width: 8),
                  _CountChip(
                    label: 'Today Visits',
                    count: controller.todayVisitCount,
                    selected: controller.selectedFilter.value == 'Today Visits',
                    color: AppColors.accentPurple,
                    onTap: () => controller.selectFilter('Today Visits'),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 10),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Obx(() {
                  final leads = controller.filteredLeads;
                  return Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      FlutterMap(
                        mapController: controller.mapController,
                        options: MapOptions(
                          initialCenter: LeadMapController.defaultCenter,
                          initialZoom: 11.2,
                          onMapReady: controller.onMapReady,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.drag |
                                InteractiveFlag.flingAnimation |
                                InteractiveFlag.pinchZoom |
                                InteractiveFlag.pinchMove |
                                InteractiveFlag.doubleTapZoom |
                                InteractiveFlag.scrollWheelZoom,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.crm_mobile_app',
                          ),
                          if (controller.showRoute.value && controller.routePoints.length > 1)
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: controller.routePoints,
                                  color: AppColors.primary,
                                  strokeWidth: 4,
                                ),
                              ],
                            ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LeadMapController.nearMePoint,
                                width: 18,
                                height: 18,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    boxShadow: const [
                                      BoxShadow(color: Colors.black26, blurRadius: 4),
                                    ],
                                  ),
                                ),
                              ),
                              ...List.generate(leads.length, (index) {
                                final lead = leads[index];
                                if (!lead.hasLocation) return null;
                                return Marker(
                                  point: LatLng(lead.latitude!, lead.longitude!),
                                  width: 40,
                                  height: 40,
                                  child: GestureDetector(
                                    onTap: () => controller.selectLead(lead),
                                    child: _MapPin(
                                      color: LeadPinStyle.colorFor(lead),
                                      selected: controller.selectedLeadId.value == lead.id,
                                    ),
                                  ),
                                );
                              }).whereType<Marker>(),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: Column(
                          children: [
                            _MapFab(
                              icon: Icons.alt_route,
                              label: 'Optimize\nRoute',
                              onTap: controller.optimizeRoute,
                            ),
                            const SizedBox(height: 10),
                            _MapFab(
                              icon: Icons.near_me_outlined,
                              label: 'Near Me',
                              onTap: controller.nearMe,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 8),
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Obx(() {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: _StatMini(
                                icon: Icons.groups_outlined,
                                value: '${controller.filteredLeads.length}',
                                label: 'Leads\nAcross city',
                                color: AppColors.primary,
                              ),
                            ),
                            Expanded(
                              child: _StatMini(
                                icon: Icons.flag_outlined,
                                value: '${controller.highPriorityCount}',
                                label: 'High Priority\nNeeds attention',
                                color: AppColors.primary,
                              ),
                            ),
                            Expanded(
                              child: _StatMini(
                                icon: Icons.directions_car_outlined,
                                value: '${controller.estimatedKm.toStringAsFixed(1)} km',
                                label: 'Est. Travel\n${controller.estimatedTime}',
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  const Divider(height: 1),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) return const LoadingView();
                      final leads = controller.filteredLeads;
                      if (leads.isEmpty) {
                        return const EmptyState(message: 'No leads on map');
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
                        itemCount: leads.length,
                        itemBuilder: (context, index) {
                          final lead = leads[index];
                          return LeadListCard(
                            index: index + 1,
                            lead: lead,
                            showIndex: false,
                            showNextStep: false,
                            selected: controller.selectedLeadId.value == lead.id,
                            checkedIn: controller.isCheckedIn(lead.id),
                            onTap: () => controller.openLeadDetail(lead),
                            onUpdate: controller.patchLead,
                            onCall: () => controller.callLead(lead),
                            onNavigate: () => controller.navigateToLead(lead),
                            onEdit: () => controller.editLead(lead),
                            onClone: () => controller.cloneLead(lead),
                            onTasks: () => controller.openLeadItems(lead, 'Tasks'),
                            onNotes: () => controller.openLeadItems(lead, 'Notes'),
                            onFiles: () => controller.openLeadItems(lead, 'Files'),
                            onDelete: () => controller.confirmDelete(lead),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _CountChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color : AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: selected ? color : AppColors.border),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: selected ? Colors.white.withValues(alpha: 0.22) : color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: selected ? Colors.white : color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final Color color;
  final bool selected;

  const _MapPin({
    required this.color,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? Colors.white : Colors.white,
          width: selected ? 3 : 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: selected ? 0.5 : 0.35),
            blurRadius: selected ? 8 : 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.place,
        size: selected ? 18 : 16,
        color: Colors.white,
      ),
    );
  }
}

class _MapFab extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MapFab({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 3,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatMini extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatMini({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(fontSize: 10, height: 1.2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
