import '../../../core/constants/app_constants.dart';
import '../../mock/mock_data.dart';
import '../../models/lead.dart';
import '../lead_repository.dart';

class MockLeadRepository implements LeadRepository {
  final List<Lead> _leads = List.from(MockData.leads);

  @override
  Future<List<Lead>> getLeads({String? query, String? filter}) async {
    await Future.delayed(AppConstants.mockDelay);
    var result = _leads.map(_ensureContact).toList();

    if (filter != null && filter.isNotEmpty && filter != 'All' && filter != 'All Leads') {
      final f = filter.toLowerCase();
      result = result.where((l) {
        if (f == 'referral leads' || f == 'referral lead') {
          return l.source.toLowerCase() == 'referrals';
        }
        if (l.tags.any((t) => t.toLowerCase() == f)) return true;
        if (f == 'today') return l.todayVisit;
        if (f == 'high priority' || f == 'very high priority') {
          return l.priority.toLowerCase().contains('high');
        }
        if (f == 'interested' || f == 'intrested') {
          return l.status.toLowerCase() == 'interested';
        }
        if (f.contains('new very high')) {
          return l.priority.toLowerCase().contains('high') && l.todayVisit;
        }
        return false;
      }).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      result = result
          .where(
            (l) =>
                l.customerName.toLowerCase().contains(q) ||
                l.businessName.toLowerCase().contains(q) ||
                l.phone.contains(q) ||
                (l.email?.toLowerCase().contains(q) ?? false),
          )
          .toList();
    }
    return result;
  }

  Lead _ensureContact(Lead lead) {
    final filled = lead.copyWith(
      phone: lead.displayPhone,
      email: lead.displayEmail,
    );
    final index = _leads.indexWhere((l) => l.id == lead.id);
    if (index >= 0) _leads[index] = filled;
    return filled;
  }

  @override
  Future<Lead> createLead(Lead lead) async {
    await Future.delayed(AppConstants.mockDelay);
    final created = _ensureContact(
      lead.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString()),
    );
    _leads.insert(0, created);
    return created;
  }

  @override
  Future<Lead> updateLead(Lead lead) async {
    await Future.delayed(AppConstants.mockDelay);
    final index = _leads.indexWhere((l) => l.id == lead.id);
    final filled = _ensureContact(lead);
    if (index >= 0) {
      _leads[index] = filled;
    }
    return filled;
  }

  @override
  Future<void> deleteLead(String id) async {
    await Future.delayed(AppConstants.mockDelay);
    _leads.removeWhere((l) => l.id == id);
  }

  @override
  Future<List<String>> getFilters() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(MockData.leadFilters);
  }

  @override
  Future<List<String>> getCustomFilters() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(MockData.leadCustomFilters);
  }
}
