class CustomerModels {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? photo;

  CustomerModels({
    this.id,
    this.firstName,
    this.lastName,
    this.photo,
  });

  factory CustomerModels.fromJson(Map<String, dynamic> json) {
    return CustomerModels(
      id: json['id'] as int?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      photo: json['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'photo': photo,
    };
  }
}
