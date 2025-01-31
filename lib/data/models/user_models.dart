class UserModels {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? aboutMySelf;
  final String? photo;
  final String? location;
  final int? id;

  UserModels({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.aboutMySelf,
    this.photo,
    this.location,
    this.id,
  });

  UserModels copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? aboutMySelf,
    String? photo,
    String? location,
    dynamic id,
  }) {
    return UserModels(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      aboutMySelf: aboutMySelf ?? this.aboutMySelf,
      photo: photo ?? this.photo,
      location: location ?? this.location,
      id: id ?? this.id,
    );
  }

  // Пример метода toJson (если нужно для сериализации)
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'aboutMySelf': aboutMySelf,
      'photo': photo,
      'location': location,
      'id': id,
    };
  }

  static UserModels fromJson(Map<String, dynamic> json) {
    return UserModels(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      aboutMySelf: json['aboutMySelf'] as String?,
      photo: json['photo'] as String?,
      location: json['location'] as String?,
      id: json['id'] != null ? json['id'] as dynamic : null,
    );
  }
}
