// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
  Map<String, dynamic> json,
) => _$TransactionModelImpl(
  id: (json['id'] as num).toInt(),
  referenceNumber: json['referenceNumber'] as String,
  type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
  amount: (json['amount'] as num).toDouble(),
  status: $enumDecode(_$TransactionStatusEnumMap, json['status']),
  fromAccountId: (json['fromAccountId'] as num?)?.toInt(),
  fromAccountNumber: json['fromAccountNumber'] as String?,
  fromAccountOwner: json['fromAccountOwner'] as String?,
  toAccountId: (json['toAccountId'] as num?)?.toInt(),
  toAccountNumber: json['toAccountNumber'] as String?,
  toAccountOwner: json['toAccountOwner'] as String?,
  description: json['description'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$$TransactionModelImplToJson(
  _$TransactionModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'referenceNumber': instance.referenceNumber,
  'type': _$TransactionTypeEnumMap[instance.type]!,
  'amount': instance.amount,
  'status': _$TransactionStatusEnumMap[instance.status]!,
  'fromAccountId': instance.fromAccountId,
  'fromAccountNumber': instance.fromAccountNumber,
  'fromAccountOwner': instance.fromAccountOwner,
  'toAccountId': instance.toAccountId,
  'toAccountNumber': instance.toAccountNumber,
  'toAccountOwner': instance.toAccountOwner,
  'description': instance.description,
  'createdAt': instance.createdAt.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
};

const _$TransactionTypeEnumMap = {
  TransactionType.deposit: 'DEPOSIT',
  TransactionType.withdraw: 'WITHDRAW',
  TransactionType.transfer: 'TRANSFER',
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'PENDING',
  TransactionStatus.completed: 'COMPLETED',
  TransactionStatus.failed: 'FAILED',
};
