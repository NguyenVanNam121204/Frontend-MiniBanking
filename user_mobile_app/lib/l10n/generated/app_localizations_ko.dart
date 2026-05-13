// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get welcomeBack => '다시 오신 것을 환영합니다';

  @override
  String get signInSubtitle => '안전한 뱅킹을 계속하려면 로그인하세요';

  @override
  String get username => '사용자 이름 / 이메일';

  @override
  String get password => '비밀번호';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get signIn => '로그인';

  @override
  String get dontHaveAccount => '계정이 없으신가요? ';

  @override
  String get registerNow => '지금 등록하세요';

  @override
  String get createAccount => '계정 만들기';

  @override
  String get joinUsSubtitle => '현대적인 뱅킹 여정을 시작하려면 가입하세요';

  @override
  String get email => '이메일 주소';

  @override
  String get register => '지금 등록하세요';

  @override
  String get alreadyHaveAccount => '이미 계정이 있으신가요? ';

  @override
  String get verifyCode => '코드 확인';

  @override
  String get resendCode => '코드 재전송';

  @override
  String get verifyContinue => '확인 및 계속';

  @override
  String get otpSubtitle =>
      'Please enter the 6-digit verification code sent to your email';

  @override
  String get didNotReceiveCode => 'Didn\'t receive the code? ';

  @override
  String get resendIn => 'Resend in ';

  @override
  String get forgotPasswordTitle => 'Forgot Password?';
}
