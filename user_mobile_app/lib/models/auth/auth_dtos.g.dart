// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestDtoImpl _$$LoginRequestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$LoginRequestDtoImpl(
  username: json['username'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$$LoginRequestDtoImplToJson(
  _$LoginRequestDtoImpl instance,
) => <String, dynamic>{
  'username': instance.username,
  'password': instance.password,
};

_$RegisterRequestDtoImpl _$$RegisterRequestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterRequestDtoImpl(
  username: json['username'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$$RegisterRequestDtoImplToJson(
  _$RegisterRequestDtoImpl instance,
) => <String, dynamic>{
  'username': instance.username,
  'email': instance.email,
  'password': instance.password,
};

_$AuthResponseDtoImpl _$$AuthResponseDtoImplFromJson(
  Map<String, dynamic> json,
) => _$AuthResponseDtoImpl(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  tokenType: json['tokenType'] as String?,
  expiresIn: (json['expiresIn'] as num?)?.toInt(),
  user: UserInfoDto.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$AuthResponseDtoImplToJson(
  _$AuthResponseDtoImpl instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'tokenType': instance.tokenType,
  'expiresIn': instance.expiresIn,
  'user': instance.user,
};

_$UserInfoDtoImpl _$$UserInfoDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserInfoDtoImpl(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      email: json['email'] as String,
      status: json['status'] as String,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$$UserInfoDtoImplToJson(_$UserInfoDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'status': instance.status,
      'roles': instance.roles,
      'createdAt': instance.createdAt,
    };

_$VerifyEmailRequestDtoImpl _$$VerifyEmailRequestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$VerifyEmailRequestDtoImpl(
  email: json['email'] as String,
  otp: json['otp'] as String,
);

Map<String, dynamic> _$$VerifyEmailRequestDtoImplToJson(
  _$VerifyEmailRequestDtoImpl instance,
) => <String, dynamic>{'email': instance.email, 'otp': instance.otp};

_$ForgotPasswordRequestDtoImpl _$$ForgotPasswordRequestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ForgotPasswordRequestDtoImpl(email: json['email'] as String);

Map<String, dynamic> _$$ForgotPasswordRequestDtoImplToJson(
  _$ForgotPasswordRequestDtoImpl instance,
) => <String, dynamic>{'email': instance.email};

_$ResetPasswordRequestDtoImpl _$$ResetPasswordRequestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ResetPasswordRequestDtoImpl(
  email: json['email'] as String,
  otp: json['otp'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$$ResetPasswordRequestDtoImplToJson(
  _$ResetPasswordRequestDtoImpl instance,
) => <String, dynamic>{
  'email': instance.email,
  'otp': instance.otp,
  'newPassword': instance.newPassword,
};
