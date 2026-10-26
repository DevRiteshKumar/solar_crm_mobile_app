class AuthUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
  });
}
