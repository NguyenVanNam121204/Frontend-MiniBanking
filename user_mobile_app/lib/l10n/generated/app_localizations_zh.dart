// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get welcomeBack => '欢迎回来';

  @override
  String get signInSubtitle => '登录以继续您的安全银行体验';

  @override
  String get username => '用户名 / 电子邮件';

  @override
  String get password => '密码';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get signIn => '登录';

  @override
  String get dontHaveAccount => '还没有账号？';

  @override
  String get registerNow => '立即注册';

  @override
  String get createAccount => '创建账号';

  @override
  String get joinUsSubtitle => '加入我们，开启您的现代银行之旅';

  @override
  String get email => '电子邮件地址';

  @override
  String get register => '立即注册';

  @override
  String get alreadyHaveAccount => '已有账号？';

  @override
  String get verifyCode => '验证码';

  @override
  String get resendCode => '重新发送代码';

  @override
  String get verifyContinue => '验证并继续';

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
