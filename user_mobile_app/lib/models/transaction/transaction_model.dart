import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

enum TransactionType {
  @JsonValue('DEPOSIT') deposit,
  @JsonValue('WITHDRAW') withdraw,
  @JsonValue('TRANSFER') transfer,
}

enum TransactionStatus {
  @JsonValue('PENDING') pending,
  @JsonValue('COMPLETED') completed,
  @JsonValue('FAILED') failed,
}

@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required int id,
    required String referenceNumber,
    required TransactionType type,
    required double amount,
    required TransactionStatus status,
    int? fromAccountId,
    String? fromAccountNumber,
    String? fromAccountOwner,
    int? toAccountId,
    String? toAccountNumber,
    String? toAccountOwner,
    String? description,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
}
