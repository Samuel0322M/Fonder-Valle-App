import 'package:hive/hive.dart';
import 'package:models/authentication_data.dart';

class SessionRepository {
  static const _boxName = 'sessionBox';
  static const _authKey = 'authData';

  /// Guarda la sesión completa (con permisos) en Hive.
  static Future<void> saveAuthenticationData(AuthenticationData data) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_authKey, data);
  }

  /// Recupera la sesión, o null si no hay.
  static Future<AuthenticationData?> loadAuthenticationData() async {
    final box = await Hive.openBox(_boxName);
    final stored = box.get(_authKey);
    if (stored is AuthenticationData) {
      return stored;
    }
    return null;
  }

  /// Limpia la sesión (logout).
  static Future<void> clearSession() async {
    final box = await Hive.openBox(_boxName);
    await box.delete(_authKey);
  }
}
