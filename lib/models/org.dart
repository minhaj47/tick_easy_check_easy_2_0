import 'dart:convert';

class Organization {
  final String id;
  final String name;
  final String description;
  final String address;
  final String logoUrl;
  final String phone;
  final String websiteUrl;
  final String email;

  Organization({
    required this.id,
    required this.name,
    required this.email,
    required this.description,
    required this.address,
    required this.logoUrl,
    required this.phone,
    required this.websiteUrl,
  });

  //. Conversion methods
  // jsonString -> jsonMap -> Organization object

  String toJson() {
    return jsonEncode({
      'id': id,
      'name': name,
      'email': email,
      'description': description,
      'address': address,
      'logoUrl': logoUrl,
      'phone': phone,
      'websiteUrl': websiteUrl,
    });
  }

  factory Organization.fromMap(Map<String, dynamic> map) {
    return Organization(
      id: map['_id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      description: map['description'] as String,
      address: map['address'] as String,
      logoUrl: map['logoUrl'] as String,
      phone: map['phone'] as String,
      websiteUrl: map['websiteUrl'] as String,
    );
  }

  factory Organization.fromJson(String source) {
    final Map<String, dynamic> json = jsonDecode(source);
    return Organization.fromMap(json);
  }
}
