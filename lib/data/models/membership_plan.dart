class MembershipPlan {
  final String id;
  final String name;
  final double pricePerMonth;
  final List<String> features;
  final String? restrictionNote;

  const MembershipPlan({
    required this.id,
    required this.name,
    required this.pricePerMonth,
    required this.features,
    this.restrictionNote,
  });
}
