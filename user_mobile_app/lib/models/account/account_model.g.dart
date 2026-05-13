// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountModelImpl _$$AccountModelImplFromJson(Map<String, dynamic> json) =>
    _$AccountModelImpl(
      id: (json['id'] as num).toInt(),
      accountNumber: json['accountNumber'] as String,
      userId: (json['userId'] as num).toInt(),
      balance: (json['balance'] as num).toDouble(),
      status: $enumDecode(_$AccountStatusEnumMap, json['status']),
      type: $enumDecode(_$AccountTypeEnumMap, json['type']),
      ownerName: json['ownerName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AccountModelImplToJson(_$AccountModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountNumber': instance.accountNumber,
      'userId': instance.userId,
      'balance': instance.balance,
      'status': _$AccountStatusEnumMap[instance.status]!,
      'type': _$AccountTypeEnumMap[instance.type]!,
      'ownerName': instance.ownerName,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'ACTIVE',
  AccountStatus.locked: 'LOCKED',
  AccountStatus.closed: 'CLOSED',
};

const _$AccountTypeEnumMap = {
  AccountType.savings: 'SAVINGS',
  AccountType.checking: 'CHECKING',
  AccountType.business: 'BUSINESS',
};
