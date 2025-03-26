import 'package:shared_preferences/shared_preferences.dart';

class StorageUtils {
  static const String _recordPrefix = 'student_record_';

  static Future<void> saveRecord(String studentName, String record) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_recordPrefix$studentName', record);
  }

  static Future<String?> getRecord(String studentName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_recordPrefix$studentName');
  }
}