class Referral {
  final String id;
  final String referredBy;
  final String leadOwner;
  final String customerName;
  final String businessName;
  final String contactNo;

  const Referral({
    required this.id,
    required this.referredBy,
    required this.leadOwner,
    required this.customerName,
    required this.businessName,
    required this.contactNo,
  });
}
