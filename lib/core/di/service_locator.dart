import 'package:get_it/get_it.dart';
import 'package:benin_experience/core/services/auth_service.dart';
import 'package:benin_experience/core/utils/permission_guard.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton(() => AuthService());
  sl.registerLazySingleton(() => PermissionGuard(sl()));
}
