import 'package:cointiply_app/core/network/base_dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../config/profile_config.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/datasources/profile_remote_data_source_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_countries_usecase.dart';
import '../../domain/usecases/get_languages_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../../domain/usecases/upload_profile_picture.dart';
import '../../domain/usecases/change_email_usecase.dart';
import '../../domain/usecases/verify_email_change_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/set_security_pin_usecase.dart';
import 'set_security_pin_notifier.dart';

/// Provider for profile remote data source
final profileRemoteDataSourceProvider =
    Provider<ProfileRemoteDataSource>((ref) {
  // 🌐 API mode: Using real backend calls
  if (ProfileConfig.enableDebugLogging) {
    debugPrint('🌐 Profile Module: Using REAL API data source');
  }
  final dio = ref.read(dioClientProvider);
  return ProfileRemoteDataSourceImpl(dioClient: dio);
});

// /// Provider for profile repository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ref.read(profileRemoteDataSourceProvider);

  return ProfileRepositoryImpl(
    remoteDataSource: remoteDataSource,
    // localDataSource: localDataSource,
    // databaseDataSource: databaseDataSource,
  );
});

/// Provider for get profile use case
final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return GetProfileUseCase(repository);
});

/// Provider for get countries use case
final getCountriesUseCaseProvider = Provider<GetCountriesUseCase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return GetCountriesUseCase(repository);
});

/// Provider for get languages use case
final getLanguagesUseCaseProvider = Provider<GetLanguagesUseCase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return GetLanguagesUseCase(repository);
});

/// Provider for update user profile use case
final updateUserProfileUseCaseProvider =
    Provider<UpdateUserProfileUsecase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return UpdateUserProfileUsecase(repository);
});

/// Provider for upload profile picture use case
final uploadProfilePictureUseCaseProvider =
    Provider<UploadProfilePictureUsecase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return UploadProfilePictureUsecase(repository);
});

/// Provider for change email use case
final changeEmailUseCaseProvider = Provider<ChangeEmailUsecase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return ChangeEmailUsecase(repository);
});

/// Provider for verify email change use case
final verifyEmailChangeUseCaseProvider =
    Provider<VerifyEmailChangeUsecase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return VerifyEmailChangeUsecase(repository);
});

/// Provider for change password use case
final changePasswordUseCaseProvider = Provider<ChangePasswordUsecase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return ChangePasswordUsecase(repository);
});

/// Provider for delete account use case
final deleteAccountUseCaseProvider = Provider<DeleteAccountUsecase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return DeleteAccountUsecase(repository);
});

/// Provider for set security PIN use case
final setSecurityPinUseCaseProvider = Provider<SetSecurityPinUsecase>((ref) {
  final repository = ref.read(profileRepositoryProvider);
  return SetSecurityPinUsecase(repository);
});

/// Provider for set security PIN notifier
final setSecurityPinNotifierProvider = StateNotifierProvider.autoDispose<
    SetSecurityPinNotifier, SetSecurityPinState>((ref) {
  final setSecurityPinUsecase = ref.read(setSecurityPinUseCaseProvider);
  return SetSecurityPinNotifier(setSecurityPinUsecase);
});
