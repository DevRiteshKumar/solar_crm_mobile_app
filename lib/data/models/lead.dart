class Lead {
  final String id;
  final String customerName;
  final String businessName;
  final String phone;
  final String? email;
  final String leadType;
  final String status;
  final String priority;
  final String source;
  final String? nextStep;
  final double? price;
  final String? lastContact;
  final String? address;
  final double? latitude;
  final double? longitude;
  final bool todayVisit;
  final List<String> tags;

  const Lead({
    required this.id,
    required this.customerName,
    required this.businessName,
    required this.phone,
    this.email,
    required this.leadType,
    required this.status,
    required this.priority,
    this.source = '',
    this.nextStep,
    this.price,
    this.lastContact,
    this.address,
    this.latitude,
    this.longitude,
    this.todayVisit = false,
    this.tags = const [],
  });

  bool get hasLocation => latitude != null && longitude != null;

  String get displayPhone {
    if (phone.trim().isNotEmpty) return phone.trim();
    final seed = (id.hashCode.abs() % 90000000) + 10000000;
    final raw = seed.toString();
    return '+91 ${raw.substring(0, 5)} ${raw.substring(5)}';
  }

  String get displayEmail {
    if (email != null && email!.trim().isNotEmpty) return email!.trim();
    return emailFromName(customerName.isNotEmpty ? customerName : businessName);
  }

  String get displayAddress {
    if (address != null && address!.trim().isNotEmpty) return address!.trim();
    return 'Address not added';
  }

  static String emailFromName(String name) {
    final local = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '.')
        .replaceAll(RegExp(r'^\.+|\.+$'), '');
    return '${local.isEmpty ? 'lead' : local}@solarcrm.in';
  }

  Lead copyWith({
    String? id,
    String? customerName,
    String? businessName,
    String? phone,
    String? email,
    String? leadType,
    String? status,
    String? priority,
    String? source,
    String? nextStep,
    double? price,
    String? lastContact,
    String? address,
    double? latitude,
    double? longitude,
    bool? todayVisit,
    List<String>? tags,
  }) {
    return Lead(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      businessName: businessName ?? this.businessName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      leadType: leadType ?? this.leadType,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      source: source ?? this.source,
      nextStep: nextStep ?? this.nextStep,
      price: price ?? this.price,
      lastContact: lastContact ?? this.lastContact,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      todayVisit: todayVisit ?? this.todayVisit,
      tags: tags ?? this.tags,
    );
  }
}
