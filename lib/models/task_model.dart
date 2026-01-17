class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final bool isStarred;
  final DateTime? dueDate; // Add this

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.isStarred = false,
    this.dueDate,
  });

  // Update toMap to include the date
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'isStarred': isStarred,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  // Update fromMap to read the date
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      isStarred: map['isStarred'] ?? false,
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
    );
  }

  Task copyWith({bool? isCompleted, bool? isStarred, DateTime? dueDate}) {
    return Task(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted ?? this.isCompleted,
      isStarred: isStarred ?? this.isStarred,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}