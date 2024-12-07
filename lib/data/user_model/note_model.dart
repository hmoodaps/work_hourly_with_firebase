// NoteModel represents individual notes such as bonuses or deductions
class NoteModel {
  String noteType; // Type of note (bonus or deduction)
  String description; // Description of the note
  double amount; // Amount of the note

  NoteModel({
    required this.noteType,
    required this.description,
    required this.amount,
  });

  // Convert NoteModel to JSON for Firebase storage
  Map<String, dynamic> toJson() {
    return {
      'noteType': noteType,
      'description': description,
      'amount': amount,
    };
  }

  // Create NoteModel from JSON
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      noteType: json['noteType'],
      description: json['description'],
      amount: json['amount'],
    );
  }
}
