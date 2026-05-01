class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  String address;
  String phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.address = '',
    this.phone = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'address': address,
        'phone': phone,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        password: json['password'] ?? '',
        address: json['address'] ?? '',
        phone: json['phone'] ?? '',
      );
}
