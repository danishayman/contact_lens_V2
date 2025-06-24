class ReminderModel {
  final DateTime startDate;
  final int intervalDays;
  final String lensType;
  final String? notes;

  ReminderModel({
    required this.startDate,
    required this.intervalDays,
    required this.lensType,
    this.notes,
  });

  // Convert model to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate.millisecondsSinceEpoch,
      'intervalDays': intervalDays,
      'lensType': lensType,
      'notes': notes,
    };
  }

  // Create model from Map (for retrieving from storage)
  factory ReminderModel.fromMap(Map<String, dynamic> map) {
    return ReminderModel(
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      intervalDays: map['intervalDays'],
      lensType: map['lensType'],
      notes: map['notes'],
    );
  }

  // Create a copy of the model with some fields changed
  ReminderModel copyWith({
    DateTime? startDate,
    int? intervalDays,
    String? lensType,
    String? notes,
  }) {
    return ReminderModel(
      startDate: startDate ?? this.startDate,
      intervalDays: intervalDays ?? this.intervalDays,
      lensType: lensType ?? this.lensType,
      notes: notes ?? this.notes,
    );
  }
}
