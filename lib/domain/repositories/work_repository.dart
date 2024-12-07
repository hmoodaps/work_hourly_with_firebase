import '../../data/user_model/note_model.dart';
import '../../data/user_model/salary_model.dart';

abstract class WorkRepository {
  Future<void> startWork();
  Future<void> addFakeWorkDays();
  Future<SalaryModel?> calculateSalary(
      {
        required DateTime startDate,
        required DateTime endDate,
        required DateTime paymentDate,
      }
      );

  Future<void> stopWork(
      {required NoteModel noteModel, required double hourlyRate});
}
