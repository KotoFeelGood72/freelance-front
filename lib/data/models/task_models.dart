import 'package:freelance/data/models/customer_models.dart';

class TaskModels {
  final int? id;
  final String? taskName;
  final String? taskDescription;
  final double? taskPrice;
  final dynamic taskTerm;
  final dynamic taskCreated;
  final String? taskCity;
  final String? taskStatus;
  final bool? isPublic;
  final CustomerModels? customer;

  TaskModels({
    this.id,
    this.taskName,
    this.taskDescription,
    this.taskPrice,
    this.taskTerm,
    this.taskCreated,
    this.taskCity,
    this.taskStatus,
    this.isPublic,
    this.customer,
  });

  factory TaskModels.fromJson(Map<String, dynamic> json) {
    return TaskModels(
      id: json['id'] as int?,
      taskName: json['taskName'] as String?,
      taskDescription: json['taskDescription'] as String?,
      taskPrice: json['taskPrice'] != null
          ? (json['taskPrice'] is int
              ? (json['taskPrice'] as int).toDouble()
              : json['taskPrice'] as double)
          : null,
      taskTerm: json['taskTerm'] as dynamic,
      taskCreated: json['taskCreated'] as dynamic,
      taskCity: json['taskCity'] as String?,
      taskStatus: json['taskStatus'] as String?,
      isPublic: json['isPublic'] as bool?,
      customer: json['customer'] != null
          ? CustomerModels.fromJson(json['customer'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskName': taskName,
      'taskDescription': taskDescription,
      'taskPrice': taskPrice,
      'taskTerm': taskTerm?.toIso8601String(),
      'taskCreated': taskCreated?.toIso8601String(),
      'taskCity': taskCity,
      'taskStatus': taskStatus,
      'isPublic': isPublic,
      'customer': customer?.toJson(),
    };
  }
}
