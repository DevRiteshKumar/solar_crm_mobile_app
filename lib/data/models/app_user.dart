class AppUser {
  final String id;
  final String contactName;
  final String contactNo;
  final String? altContactNo;
  final String email;
  final String? address;
  final String role;

  const AppUser({
    required this.id,
    required this.contactName,
    required this.contactNo,
    this.altContactNo,
    required this.email,
    this.address,
    required this.role,
  });
}
