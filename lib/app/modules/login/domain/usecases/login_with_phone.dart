import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:guard_class/app/modules/login/domain/entities/logged_user_info.dart';
import 'package:guard_class/app/modules/login/domain/entities/login_credential.dart';
import 'package:guard_class/app/modules/login/domain/errors/errors.dart';
import 'package:guard_class/app/modules/login/domain/repositories/login_repository.dart';
part 'login_with_phone.g.dart';

abstract class LoginWithPhone {
  Future<Either<Failure, LoggedUserInfo>> call(LoginCredential credencial);
}

@Injectable(singleton: false)
class LoginWithPhoneImpl implements LoginWithPhone {
  final LoginRepository repository;

  LoginWithPhoneImpl(this.repository);

  @override
  Future<Either<Failure, LoggedUserInfo>> call(
      LoginCredential credencial) async {
    if (!credencial.isValidPhone) {
      return Left(ErrorLoginPhone(message: "Invalid Phone number"));
    }
    return await repository.loginPhone(phone: credencial.phone);
  }
}
