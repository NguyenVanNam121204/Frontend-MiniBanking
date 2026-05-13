// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get welcomeBack => 'おかえりなさい';

  @override
  String get signInSubtitle => '安全な銀行取引を続けるためにログインしてください';

  @override
  String get username => 'ユーザー名 / メールアドレス';

  @override
  String get password => 'パスワード';

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get signIn => 'ログイン';

  @override
  String get dontHaveAccount => 'アカウントをお持ちではありませんか？';

  @override
  String get registerNow => '今すぐ登録';

  @override
  String get createAccount => 'アカウント作成';

  @override
  String get joinUsSubtitle => 'モダンな銀行体験を始めるために参加しましょう';

  @override
  String get email => 'メールアドレス';

  @override
  String get register => '今すぐ登録';

  @override
  String get alreadyHaveAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get verifyCode => 'コードを確認';

  @override
  String get resendCode => 'コードを再送';

  @override
  String get verifyContinue => '確認して続行';

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
