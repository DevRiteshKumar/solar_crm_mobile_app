import 'lead.dart';

class DashboardStats {
  final int totalLeads;
  final int totalContacts;
  final int totalReferrers;
  final int totalTasks;
  final String userName;
  final String planExpiryMessage;
  final List<Lead> leadsByStatus;
  final List<Lead> leadsByPriority;
  final List<Lead> leadOverview;
  final List<Lead> leadFinancials;
  final List<Lead> leadsByNextStep;
  final List<Lead> leadsCompleted;

  const DashboardStats({
    required this.totalLeads,
    required this.totalContacts,
    required this.totalReferrers,
    required this.totalTasks,
    required this.userName,
    required this.planExpiryMessage,
    this.leadsByStatus = const [],
    this.leadsByPriority = const [],
    this.leadOverview = const [],
    this.leadFinancials = const [],
    this.leadsByNextStep = const [],
    this.leadsCompleted = const [],
  });
}
