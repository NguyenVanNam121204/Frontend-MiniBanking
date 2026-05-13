// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get welcomeBack => 'Chào mừng trở lại';

  @override
  String get signInSubtitle =>
      'Đăng nhập để tiếp tục trải nghiệm ngân hàng an toàn';

  @override
  String get username => 'Tên đăng nhập / Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get dontHaveAccount => 'Chưa có tài khoản? ';

  @override
  String get registerNow => 'Đăng ký ngay';

  @override
  String get createAccount => 'Tạo tài khoản';

  @override
  String get joinUsSubtitle =>
      'Tham gia cùng chúng tôi để bắt đầu hành trình ngân hàng hiện đại';

  @override
  String get email => 'Địa chỉ Email';

  @override
  String get register => 'Đăng ký ngay';

  @override
  String get alreadyHaveAccount => 'Đã có tài khoản? ';

  @override
  String get verifyCode => 'Xác nhận mã';

  @override
  String get resendCode => 'Gửi lại mã';

  @override
  String get verifyContinue => 'Xác nhận & Tiếp tục';

  @override
  String get otpSubtitle =>
      'Vui lòng nhập mã xác thực 6 chữ số đã được gửi tới email';

  @override
  String get didNotReceiveCode => 'Bạn không nhận được mã? ';

  @override
  String get resendIn => 'Gửi lại sau ';

  @override
  String get forgotPasswordTitle => 'Quên mật khẩu?';
}
