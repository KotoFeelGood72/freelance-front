class TaskState {
  final String taskName;
  final int taskPrice;
  final List<dynamic> tasks;
  final List<dynamic> taskResponses;
  final DateTime? taskTerm;
  final String taskCity;
  final String taskDescription;
  final bool isValid;
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;
  final Map<String, dynamic>? currentTask;
  bool isErrorShown;

  TaskState({
    this.tasks = const [],
    this.taskResponses = const [],
    this.taskName = '',
    this.taskPrice = 0,
    this.taskTerm,
    this.taskCity = '',
    this.taskDescription = '',
    this.isValid = false,
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
    this.isErrorShown = false,
    this.currentTask,
  });

  TaskState copyWith({
    List<dynamic>? tasks,
    List<dynamic>? taskResponses,
    String? taskName,
    int? taskPrice,
    DateTime? taskTerm,
    String? taskCity,
    String? taskDescription,
    bool? isValid,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
    bool? isErrorShown,
    Map<String, dynamic>? currentTask,
  }) {
    return TaskState(
      taskResponses: taskResponses ?? this.taskResponses,
      tasks: tasks ?? this.tasks,
      taskName: taskName ?? this.taskName,
      taskPrice: taskPrice ?? this.taskPrice,
      taskTerm: taskTerm ?? this.taskTerm,
      taskCity: taskCity ?? this.taskCity,
      taskDescription: taskDescription ?? this.taskDescription,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      isErrorShown: isErrorShown ?? this.isErrorShown,
      currentTask: currentTask ?? this.currentTask,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskName': taskName,
      'taskPrice': taskPrice,
      'taskTerm': taskTerm?.toIso8601String(),
      'taskCity': taskCity,
      'taskDescription': taskDescription,
    };
  }
}
