import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guard_class/app/modules/login/data/models/user_model.dart';
import 'package:guard_class/app/modules/login/domain/entities/login_credential.dart';
import 'package:guard_class/app/modules/login/domain/errors/errors.dart';
import 'package:guard_class/app/modules/login/domain/repositories/login_repository.dart';
import 'package:guard_class/app/modules/login/domain/usecases/verify_phone_code.dart';
import 'package:mockito/mockito.dart';

class LoginRepositoryMock extends Mock implements LoginRepository {}

class FirebaseUserMock extends Mock implements FirebaseUser {}

main() {
  final repository = LoginRepositoryMock();
  final usecase = VerifyPhoneCodeImpl(repository);
  test('should verify if code is not valid', () async {
    var result = await usecase(
        LoginCredential.withVerificationCode(code: "", verificationId: ""));
    expect(result.leftMap((l) => l is ErrorLoginPhone), Left(true));
  });
  test('should verify if verificationId is not valid', () async {
    var result = await usecase(
        LoginCredential.withVerificationCode(code: "1234", verificationId: ""));
    expect(result.leftMap((l) => l is InternalError), Left(true));
  });
  test('should consume repository verifyPhoneCode', () async {
    var user = UserModel(name: "null");
    when(repository.verifyPhoneCode(
            code: anyNamed('code'), verificationId: anyNamed('verificationId')))
        .thenAnswer((_) async => Right(user));
    var result = await usecase(LoginCredential.withVerificationCode(
        code: "1234", verificationId: "1233233"));

    expect(result, Right(user));
  });
}
