class LeadTask {
  final String id;
  final String title;
  final String category;
  final String responsible;
  final String startDate;
  final String dueDate;
  final String time;
  final String reminder;
  final String priority;
  final String status;
  final String description;

  const LeadTask({
    required this.id,
    required this.title,
    this.category = '',
    this.responsible = '',
    this.startDate = '',
    this.dueDate = '',
    this.time = '',
    this.reminder = '',
    this.priority = 'Medium',
    this.status = 'New',
    this.description = '',
  });
}

class LeadNote {
  final String id;
  final String description;
  final String createdAt;

  const LeadNote({
    required this.id,
    required this.description,
    required this.createdAt,
  });
}

class LeadCallLog {
  final String id;
  final String status;
  final String followUpDate;
  final String note;
  final String createdAt;

  const LeadCallLog({
    required this.id,
    required this.status,
    required this.followUpDate,
    required this.note,
    required this.createdAt,
  });
}

class LeadFileItem {
  final String id;
  final String documentType;
  final String owner;
  final String title;
  final String content;

  const LeadFileItem({
    required this.id,
    required this.documentType,
    required this.owner,
    required this.title,
    this.content = '',
  });
}

class RoofRecord {
  final int serial;
  final String type;
  final String areaSqFt;

  const RoofRecord({
    required this.serial,
    required this.type,
    required this.areaSqFt,
  });
}

class LeadSiteInfo {
  final String town;
  final String state;
  final String monthlyUnits;
  final String monthlyBill;
  final String sanctionedLoad;
  final String lastBillDate;
  final String connectionType;
  final String solarSizeOffered;
  final String inverterType;
  final String panelToInverter;
  final String inverterToAcjb;
  final String acjbToLoad;
  final List<RoofRecord> roofs;

  const LeadSiteInfo({
    this.town = '—',
    this.state = '—',
    this.monthlyUnits = '—',
    this.monthlyBill = '—',
    this.sanctionedLoad = '—',
    this.lastBillDate = '—',
    this.connectionType = '—',
    this.solarSizeOffered = '—',
    this.inverterType = '—',
    this.panelToInverter = '—',
    this.inverterToAcjb = '—',
    this.acjbToLoad = '—',
    this.roofs = const [],
  });
}
