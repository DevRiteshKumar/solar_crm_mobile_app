import '../models/lead.dart';

abstract class LeadRepository {
  Future<List<Lead>> getLeads({String? query, String? filter});

  Future<Lead> createLead(Lead lead);

  Future<Lead> updateLead(Lead lead);

  Future<void> deleteLead(String id);

  Future<List<String>> getFilters();

  Future<List<String>> getCustomFilters();
}
