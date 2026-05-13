import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_model.freezed.dart';
part 'account_model.g.dart';

enum AccountType {
  @JsonValue('SAVINGS')
  savings,
  @JsonValue('CHECKING')
  checking,
  @JsonValue('BUSINESS')
  business,
}

enum AccountStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('LOCKED')
  locked,
  @JsonValue('CLOSED')
  closed,
}

@freezed
class AccountModel with _$AccountModel {
  const factory AccountModel({
    required int id,
    required String accountNumber,
    required int userId,
    required double balance,
    required AccountStatus status,
    required AccountType type,
    String? ownerName,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AccountModel;

  factory AccountModel.fromJson(Map<String, dynamic> json) => _$AccountModelFromJson(json);
}
