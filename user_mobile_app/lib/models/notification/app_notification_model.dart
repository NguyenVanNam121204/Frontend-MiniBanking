enum AppNotificationType { transaction, security, system }

class AppNotificationModel {
  final int id;
  final String title;
  final String body;
  final DateTime createdAt;
  final AppNotificationType type;
  final bool isRead;

  const AppNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.type,
    required this.isRead,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? '') as String,
      body: (json['body'] ?? '') as String,
      createdAt:
          DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.now(),
      type: _mapType((json['type'] ?? '').toString()),
      isRead: json['read'] == true,
    );
  }

  AppNotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? createdAt,
    AppNotificationType? type,
    bool? isRead,
  }) {
    return AppNotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }

  static AppNotificationType _mapType(String raw) {
    switch (raw.toUpperCase()) {
      case 'TRANSACTION':
        return AppNotificationType.transaction;
      case 'SECURITY':
        return AppNotificationType.security;
      default:
        return AppNotificationType.system;
    }
  }
}
