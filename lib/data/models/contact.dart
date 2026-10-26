class Contact {
  final String id;
  final String firstName;
  final String lastName;
  final String? jobTitle;
  final String? companyName;
  final String phone1;
  final String? phone2;
  final String? email;
  final String? industry;
  final String? description;
  final String? streetAddress;
  final String? city;
  final String? state;
  final String? country;
  final String? zipcode;

  const Contact({
    required this.id,
    required this.firstName,
    this.lastName = '',
    this.jobTitle,
    this.companyName,
    required this.phone1,
    this.phone2,
    this.email,
    this.industry,
    this.description,
    this.streetAddress,
    this.city,
    this.state,
    this.country,
    this.zipcode,
  });

  String get fullName => '$firstName $lastName'.trim();

  Contact copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? jobTitle,
    String? companyName,
    String? phone1,
    String? phone2,
    String? email,
    String? industry,
    String? description,
    String? streetAddress,
    String? city,
    String? state,
    String? country,
    String? zipcode,
  }) {
    return Contact(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      phone1: phone1 ?? this.phone1,
      phone2: phone2 ?? this.phone2,
      email: email ?? this.email,
      industry: industry ?? this.industry,
      description: description ?? this.description,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zipcode: zipcode ?? this.zipcode,
    );
  }
}
