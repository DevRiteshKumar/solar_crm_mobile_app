import 'package:get/get.dart';
import '../../data/models/lead_options.dart';

class LeadOptionsController extends GetxController {
  final extraPriorities = <String>[].obs;
  final extraSources = <String>[].obs;
  final extraStatuses = <String>[].obs;
  final extraNextSteps = <String>[].obs;

  List<String> priorities([String? current]) =>
      _merge(LeadOptions.priorities, extraPriorities, current);

  List<String> sources([String? current]) =>
      _merge(LeadOptions.sources, extraSources, current);

  List<String> statuses([String? current]) =>
      _merge(LeadOptions.statuses, extraStatuses, current);

  List<String> nextSteps([String? current]) =>
      _merge(LeadOptions.nextSteps, extraNextSteps, current);

  void addPriority(String value) => _add(extraPriorities, LeadOptions.priorities, value);

  void addSource(String value) => _add(extraSources, LeadOptions.sources, value);

  void addStatus(String value) => _add(extraStatuses, LeadOptions.statuses, value);

  void addNextStep(String value) => _add(extraNextSteps, LeadOptions.nextSteps, value);

  List<String> _merge(List<String> base, List<String> extra, String? current) {
    final seen = <String>{};
    final result = <String>[];
    for (final item in [...base, ...extra, if (current != null && current.trim().isNotEmpty) current]) {
      final key = item.toLowerCase();
      if (seen.add(key)) result.add(item);
    }
    return result;
  }

  void _add(RxList<String> extra, List<String> base, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    final exists = [...base, ...extra].any((e) => e.toLowerCase() == trimmed.toLowerCase());
    if (!exists) extra.add(trimmed);
  }
}
