import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_dtos.freezed.dart';
part 'auth_dtos.g.dart';

@freezed
class LoginRequestDto with _$LoginRequestDto {
  const factory LoginRequestDto({
    required String username,
    required String password,
  }) = _LoginRequestDto;

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) => _$LoginRequestDtoFromJson(json);
}

@freezed
class RegisterRequestDto with _$RegisterRequestDto {
  const factory RegisterRequestDto({
    required String username,
    required String email,
    required String password,
  }) = _RegisterRequestDto;

  factory RegisterRequestDto.fromJson(Map<String, dynamic> json) => _$RegisterRequestDtoFromJson(json);
}

@freezed
class AuthResponseDto with _$AuthResponseDto {
  const factory AuthResponseDto({
    required String accessToken,
    required String refreshToken,
    String? tokenType,
    int? expiresIn,
    required UserInfoDto user,
  }) = _AuthResponseDto;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) => _$AuthResponseDtoFromJson(json);
}

@freezed
class UserInfoDto with _$UserInfoDto {
  const factory UserInfoDto({
    required int id,
    required String username,
    required String email,
    required String status,
    required List<String> roles,
    String? createdAt,
  }) = _UserInfoDto;

  factory UserInfoDto.fromJson(Map<String, dynamic> json) => _$UserInfoDtoFromJson(json);
}

@freezed
class VerifyEmailRequestDto with _$VerifyEmailRequestDto {
  const factory VerifyEmailRequestDto({
    required String email,
    required String otp,
  }) = _VerifyEmailRequestDto;

  factory VerifyEmailRequestDto.fromJson(Map<String, dynamic> json) => _$VerifyEmailRequestDtoFromJson(json);
}

@freezed
class ForgotPasswordRequestDto with _$ForgotPasswordRequestDto {
  const factory ForgotPasswordRequestDto({
    required String email,
  }) = _ForgotPasswordRequestDto;

  factory ForgotPasswordRequestDto.fromJson(Map<String, dynamic> json) => _$ForgotPasswordRequestDtoFromJson(json);
}

@freezed
class ResetPasswordRequestDto with _$ResetPasswordRequestDto {
  const factory ResetPasswordRequestDto({
    required String email,
    required String otp,
    required String newPassword,
  }) = _ResetPasswordRequestDto;

  factory ResetPasswordRequestDto.fromJson(Map<String, dynamic> json) => _$ResetPasswordRequestDtoFromJson(json);
}
