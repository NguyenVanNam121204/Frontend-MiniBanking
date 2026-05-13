// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInSubtitle => 'Sign in to continue your secure banking';

  @override
  String get username => 'Username / Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get registerNow => 'Register Now';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinUsSubtitle => 'Join us to start your modern banking journey';

  @override
  String get email => 'Email Address';

  @override
  String get register => 'Register Now';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get verifyContinue => 'Verify & Continue';

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
