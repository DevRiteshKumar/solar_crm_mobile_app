import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../data/models/lead.dart';
import '../../data/repositories/lead_repository.dart';
import '../leads/leads_controller.dart';

class LeadMapController extends GetxController {
  final LeadRepository _repository = Get.find();

  final mapController = MapController();
  final isLoading = false.obs;
  final allLeads = <Lead>[].obs;
  final selectedFilter = 'All Leads'.obs;
  final selectedLeadId = RxnString();
  final showRoute = false.obs;
  final mapReady = false.obs;

  static const LatLng defaultCenter = LatLng(13.3409, 74.7421);
  static const LatLng nearMePoint = LatLng(13.3409, 74.7421);

  List<Lead> get filteredLeads {
    final list = allLeads.toList();
    switch (selectedFilter.value) {
      case 'High Priority':
        return list.where((l) => l.priority.toLowerCase().contains('high')).toList();
      case 'Today Visits':
        return list.where((l) => l.todayVisit).toList();
      default:
        return list;
    }
  }

  int get highPriorityCount =>
      allLeads.where((l) => l.priority.toLowerCase().contains('high')).length;

  int get todayVisitCount => allLeads.where((l) => l.todayVisit).length;

  double get estimatedKm {
    final points = routePoints;
    if (points.length < 2) return 0;
    const distance = Distance();
    var total = 0.0;
    for (var i = 0; i < points.length - 1; i++) {
      total += distance.as(LengthUnit.Kilometer, points[i], points[i + 1]);
    }
    return total;
  }

  String get estimatedTime {
    final hours = estimatedKm / 22;
    final totalMinutes = (hours * 60).round().clamp(0, 24 * 60);
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    if (h == 0) return '${m}m';
    return '${h}h ${m.toString().padLeft(2, '0')}m';
  }

  List<LatLng> get routePoints {
    return filteredLeads
        .where((l) => l.hasLocation)
        .map((l) => LatLng(l.latitude!, l.longitude!))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    try {
      isLoading.value = true;
      allLeads.assignAll(await _repository.getLeads());
    } finally {
      isLoading.value = false;
    }
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
    selectedLeadId.value = null;
    showRoute.value = false;
    fitBounds();
  }

  void selectLead(Lead lead) {
    selectedLeadId.value = lead.id;
    if (lead.hasLocation) {
      _safeMove(LatLng(lead.latitude!, lead.longitude!), 14.5);
    }
  }

  void onMapReady() {
    mapReady.value = true;
    fitBounds();
  }

  void fitBounds() {
    if (!mapReady.value) return;
    final points = routePoints;
    try {
      if (points.isEmpty) {
        mapController.move(defaultCenter, 12);
        return;
      }
      if (points.length == 1) {
        mapController.move(points.first, 14);
        return;
      }
      final bounds = LatLngBounds.fromPoints(points);
      mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.fromLTRB(40, 40, 40, 40)),
      );
    } catch (_) {
      _safeMove(points.isNotEmpty ? points.first : defaultCenter, 12);
    }
  }

  void _safeMove(LatLng point, double zoom) {
    if (!mapReady.value) return;
    try {
      mapController.move(point, zoom);
    } catch (_) {}
  }

  void nearMe() {
    _safeMove(nearMePoint, 13.5);
    Get.snackbar('Near Me', 'Centered on your current area', snackPosition: SnackPosition.BOTTOM);
  }

  void optimizeRoute() {
    if (routePoints.length < 2) {
      Get.snackbar('Route', 'Need at least 2 leads with location', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    showRoute.value = true;
    fitBounds();
    Get.snackbar(
      'Route optimized',
      '${estimatedKm.toStringAsFixed(1)} km · $estimatedTime',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  bool isCheckedIn(String id) {
    if (Get.isRegistered<LeadsController>()) {
      return Get.find<LeadsController>().checkedInIds.contains(id);
    }
    return false;
  }

  void callLead(Lead lead) {
    if (Get.isRegistered<LeadsController>()) {
      Get.find<LeadsController>().callLead(lead);
    }
  }

  void whatsappLead(Lead lead) {
    if (Get.isRegistered<LeadsController>()) {
      Get.find<LeadsController>().whatsappLead(lead);
    }
  }

  void navigateToLead(Lead lead) {
    if (Get.isRegistered<LeadsController>()) {
      Get.find<LeadsController>().navigateToLead(lead);
    }
  }

  void checkInLead(Lead lead) {
    if (Get.isRegistered<LeadsController>()) {
      Get.find<LeadsController>().checkInLead(lead);
      allLeads.refresh();
    }
  }

}
