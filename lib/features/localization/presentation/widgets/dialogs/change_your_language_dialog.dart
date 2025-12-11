import 'package:cointiply_app/core/common/common_dropdown_field_with_icon.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/common/dialog_bg_widget.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/features/localization/presentation/providers/localization_notifier_provider.dart';
import 'package:cointiply_app/features/localization/presentation/providers/localization_state.dart';
import 'package:cointiply_app/features/user_profile/domain/entities/language.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/change_language_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/get_languages_state.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/get_profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void showChangeLanguageDialog(BuildContext context) {
  context.showManagePopup(
    // height: 400,
    child: const ChangeLanguageDialog(),
    // title: context.translate("change_your_language_title")
  );
}

class ChangeLanguageDialog extends ConsumerStatefulWidget {
  const ChangeLanguageDialog({super.key});

  @override
  ConsumerState<ChangeLanguageDialog> createState() =>
      _ChangeLanguageDialogState();
}

class _ChangeLanguageDialogState extends ConsumerState<ChangeLanguageDialog> {
  Language? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    // Fetch languages when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(getLanguagesNotifierProvider.notifier).fetchLanguages();
    });

    ref.listenManual(
      getLanguagesNotifierProvider,
      (previous, next) {
        if (next.hasData &&
            next.languages != null &&
            next.languages!.isNotEmpty) {
          // Try to find the default language or select the first one

          final profile = ref.watch(getProfileNotifierProvider).profile;
          final language = profile?.settings.language;

          final defaultLanguage = next.languages!.firstWhere(
            (lang) => lang.code.toLowerCase() == language?.toLowerCase(),
            orElse: () => next.languages!.first,
          );
          setState(() {
            _selectedLanguage = defaultLanguage;
          });
        }
      },
    );

    ref.listenManual(
      changeLanguageProvider,
      (previous, next) async {
        if (next.isChanging) {
          // Show loading indicator or disable inputs
        } else if (next.status == ChangeLanguageStatus.success) {
          // Show success message
          context.showSuccessSnackBar(
            message: context.translate("language_changed_successfully"),
          );
          ref
              .read(getProfileNotifierProvider.notifier)
              .fetchProfile(isLoading: false);
          // Close dialog on success
          if (mounted) {
            context.pop();
          }
        } else if (next.hasError) {
          // Show error message
          final errorMessage = next.errorMessage ??
              context.translate("failed_to_change_language");
          context.showSnackBar(
              message: errorMessage, backgroundColor: context.error);
        }
      },
    );
    ref.listenManual(
      localizationNotifierProvider,
      (previous, next) async {
        if (previous != next) {
          if (next.status == LocalizationStatus.error) {
            // Show error message
            final errorMessage =
                next.error ?? context.translate("failed_to_change_language");
            context.showSnackBar(
                message: errorMessage, backgroundColor: context.error);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _manageDialogBody(context);
  }

  Widget _manageDialogBody(BuildContext context) {
    final languagesState = ref.watch(getLanguagesNotifierProvider);
    final isChangingLanguage = ref.watch(changeLanguageProvider).isChanging ||
        ref.watch(localizationNotifierProvider).status ==
            LocalizationStatus.loading;
    final userId = (ref.read(currentUserProvider).user?.id ?? 0).toString();

    return DialogBgWidget(
      title: context.translate("change_your_language_title"),
      dialogHeight: context.isDesktop
          ? 340
          : context.isTablet
              ? 350
              : 400,
      body: SingleChildScrollView(
        padding: context.isMobile || context.isTablet
            ? const EdgeInsets.symmetric(horizontal: 17, vertical: 22)
            : const EdgeInsets.symmetric(horizontal: 31, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CommonText.bodyMedium(
                context.translate("change_your_language_description"),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 13),
            // Languages dropdown
            if (languagesState.isLoading)
              _loadingState()
            else if (languagesState.hasError)
              _errorState(languagesState, context)
            else if (languagesState.hasData)
              _dataState(languagesState, context),

            const SizedBox(height: 24),
            CustomUnderLineButtonWidget(
              title: context.translate('change_your_language_btn_text'),
              fontSize: 14,
              isDark: true,
              width: 250,
              fontWeight: FontWeight.w700,
              onTap: _selectedLanguage != null
                  ? () {
                      ref
                          .read(localizationNotifierProvider.notifier)
                          .changeLocale(
                            Locale(_selectedLanguage!.code.toLowerCase(),
                                _selectedLanguage!.code.toUpperCase()),
                            userid: userId,
                          );
                    }
                  : null,
              isLoading: isChangingLanguage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataState(GetLanguagesState languagesState, BuildContext context) {
    final isMobile = context.isMobile;

    return isMobile || context.isTablet
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              CommonText.bodyMedium(
                context.translate("your_language"),
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              SearchableDropdownWithIcon<Language>(
                items: (filter, infiniteScrollProps) =>
                    languagesState.languages!,
                selectedItem: _selectedLanguage,
                onChanged: (language) {
                  setState(() {
                    _selectedLanguage = language;
                  });
                },
                // labelText: context.translate("language"),
                // hint: context.translate("select_your_language_hint"),
                getItemCode: (language) => language.code,
                getItemName: (language) => language.name,
                getItemIconUrl: (language) =>
                    language.getDisplayFlag(language.code),
                validator: (value) {
                  if (value == null) {
                    return context.translate("please_select_language_error");
                  }
                  return null;
                },
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 1,
                child: CommonText.bodyMedium(
                  context.translate("your_language"),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                flex: 2,
                child: SearchableDropdownWithIcon<Language>(
                  items: (filter, infiniteScrollProps) =>
                      languagesState.languages!,
                  selectedItem: _selectedLanguage,
                  onChanged: (language) {
                    setState(() {
                      _selectedLanguage = language;
                    });
                  },
                  // labelText: context.translate("language"),
                  // hint: context.translate("select_your_language_hint"),
                  getItemCode: (language) => language.code,
                  getItemName: (language) => language.name,
                  getItemIconUrl: (language) =>
                      language.getDisplayFlag(language.code),
                  validator: (value) {
                    if (value == null) {
                      return context.translate("please_select_language_error");
                    }
                    return null;
                  },
                ),
              ),
            ],
          );
  }

  Center _errorState(GetLanguagesState languagesState, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CommonText.bodyMedium(
              languagesState.errorMessage ??
                  context.translate("failed_to_load_languages"),
              textAlign: TextAlign.center,
              color: context.error,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                ref
                    .read(getLanguagesNotifierProvider.notifier)
                    .fetchLanguages();
              },
              child: CommonText.bodyMedium(
                context.translate("retry_button"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center _loadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
