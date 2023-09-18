import 'package:shared_preferences/shared_preferences.dart';

class PersistantPrefernceStorage {
  Future<SharedPreferences> getInstance() async {
    return await SharedPreferences.getInstance();
  }
}
