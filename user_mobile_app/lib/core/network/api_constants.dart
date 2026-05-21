class ApiConstants {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyEmail = '/auth/verify-email';
  static const String resendOtp = '/auth/resend-verification';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyResetOtp = '/auth/verify-reset-otp';
  static const String refreshToken = '/auth/refresh-token';

  // User
  static const String profile = '/users/profile';
  static const String changePassword = '/users/change-password';
  static const String setupPin = '/users/setup-pin';
  static const String changePin = '/users/change-pin';
  static const String verifyPin = '/users/verify-pin';

  // Accounts
  static const String accounts = '/accounts';
  static String searchAccount(String number) => '/accounts/search/$number';
  
  // Transactions
  static const String transactions = '/transactions';
  static const String deposit = '/transactions/deposit';
  static const String withdraw = '/transactions/withdraw';
  static const String transfer = '/transactions/transfer';
  static const String history = '/transactions/history';

  // Notifications
  static const String notifications = '/notifications';
  static String markNotificationAsRead(int id) => '/notifications/$id/read';
  static const String markAllNotificationsAsRead = '/notifications/read-all';
  static String deleteNotification(int id) => '/notifications/$id';
}
