import 'package:cointiply_app/core/common/common_dropdown_field_with_icon.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/custom_buttom_widget.dart';
import 'package:cointiply_app/core/common/dialog_bg_widget.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/features/auth/presentation/providers/selected_country_provider.dart';
import 'package:cointiply_app/features/user_profile/domain/entities/country.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/change_country_notifier.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/current_user_provider.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/get_countries_state.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/get_profile_notifier.dart';
import 'package:cointiply_app/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showChangeCountryDialog(BuildContext context) {
  context.showManagePopup(
    barrierDismissible: true,
    // height: context.isMobile ? context.screenHeight * 0.7 : 400,
    child: const ChangeCountryDialog(),
    // title: context.translate("change_your_country_title")
  );
}

class ChangeCountryDialog extends ConsumerStatefulWidget {
  const ChangeCountryDialog({super.key});

  @override
  ConsumerState<ChangeCountryDialog> createState() =>
      _ChangeCountryDialogState();
}

class _ChangeCountryDialogState extends ConsumerState<ChangeCountryDialog> {
  // Country? _selectedCountry;
  Country? _previousCountry; // To store the previously selected country

  @override
  void initState() {
    super.initState();
    // Fetch countries when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(getCountriesNotifierProvider.notifier).fetchCountries();
    });
    ref.listenManual(
      getCountriesNotifierProvider,
      (previous, next) {
        if (next.hasData &&
            next.countries != null &&
            next.countries!.isNotEmpty) {
          final profile = ref.watch(getProfileNotifierProvider).profile;
          final currentCountry = profile?.account.country?.id;
          if (currentCountry != null) {
            final countriesState = ref.read(getCountriesNotifierProvider);
            final country = countriesState.countries
                ?.firstWhere((country) => country.id == currentCountry);
            ref.read(selectedCountryProvider.notifier).state = country;
            setState(() {
              _previousCountry = country; // Store the initial country
            });
          }
        }
      },
    );

    ref.listenManual(
      changeCountryProvider,
      (previous, next) async {
        if (next.isChanging) {
          // Show loading indicator or disable inputs
        } else if (next.status == ChangeCountryStatus.success) {
          // Close dialog on success
          context.showSuccessSnackBar(message: "Country changed successfully");
          ref
              .read(getProfileNotifierProvider.notifier)
              .fetchProfile(isLoading: false);
          ref.read(currentUserProvider.notifier).getCurrentUser();

          if (mounted) {
            context.pop();
          }
        } else if (next.hasError) {
          // Show error message
          final errorMessage = next.errorMessage ??
              context.translate("failed_to_change_country");
          context.showSnackBar(
              message: errorMessage, backgroundColor: context.error);
        }
      },
    );
  }

  void _onChangeCountry() {
    // If the selected country is the same as the previous one, show an error message
    if (ref.read(selectedCountryProvider) == _previousCountry) {
      context.showSnackBar(
        message: context.translate('country_not_changed_error'),
        backgroundColor: context.error,
      );
      return;
    }

    // Proceed with changing the country if it's different
    final userId = (ref.read(currentUserProvider).user?.id ?? 0).toString();
    ref.read(changeCountryProvider.notifier).changeCountry(
          countryId: ref.read(selectedCountryProvider)!.id,
          countryName: ref.read(selectedCountryProvider)!.name,
          userid: userId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final countriesState = ref.watch(getCountriesNotifierProvider);
    final isChangingCountry = ref.watch(changeCountryProvider).isChanging;
    final selectedCountry = ref.watch(selectedCountryProvider);

    return DialogBgWidget(
        dialogHeight: context.isDesktop ? 370 : 440,
        isInitLoading: countriesState.isLoading,
        isOverlayLoading: isChangingCountry,
        title: context.translate("change_your_country_title"),
        body: _manageDialogBody(
            context, selectedCountry, isChangingCountry, countriesState));
  }

  Widget _manageDialogBody(BuildContext context, Country? selectedCountry,
      bool isChangingCountry, GetCountriesState countriesState) {
    return SingleChildScrollView(
      child: Container(
        padding: context.isDesktop ? EdgeInsets.all(32) : EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CommonText.bodyMedium(
                  context.translate("change_your_country_description"),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Countries dropdown
            if (countriesState.isLoading)
              _loadingState()
            else if (countriesState.hasError)
              _errorState(countriesState, context)
            else if (countriesState.hasData)
              _dataState(countriesState, context),

            const SizedBox(height: 24),

            CustomUnderLineButtonWidget(
              width: context.isDesktop ? 250 : double.infinity,
              title: context.translate("change_your_country_btn_text"),
              fontSize: 14,
              isDark: true,
              fontWeight: FontWeight.w700,
              onTap: selectedCountry != null ? _onChangeCountry : null,
            )
          ],
        ),
      ),
    );
  }

  Widget _dataState(GetCountriesState countriesState, BuildContext context) {
    final isDesktop = context.isDesktop;

    return isDesktop
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 12.0,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 1,
                    child: CommonText.bodyLarge(
                      context.translate("your_country"),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: SearchableDropdownWithIcon<Country>(
                        items: (filter, infiniteScrollProps) =>
                            countriesState.countries!,
                        selectedItem: ref.read(selectedCountryProvider),
                        onChanged: (country) {
                          ref.read(selectedCountryProvider.notifier).state =
                              country;
                        },
                        getItemCode: (country) => country.code,
                        getItemName: (country) => country.name,
                        getItemIconUrl: (country) => country.flag,
                        placeholder: Icon(
                          Icons.flag,
                          color: context.primary,
                        ),
                        validator: (value) {
                          if (value == null) {
                            return context
                                .translate("please_select_country_error");
                          }
                          return null;
                        },
                      )),
                ],
              ),
              CommonText.bodySmall(
                context.translate("change_your_country_note"),
                color: Color(0xff98989A),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 12.0,
            children: [
              CommonText.bodyLarge(
                context.translate("your_country"),
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              SearchableDropdownWithIcon<Country>(
                items: (filter, infiniteScrollProps) =>
                    countriesState.countries!,
                selectedItem: ref.read(selectedCountryProvider),
                onChanged: (country) {
                  ref.read(selectedCountryProvider.notifier).state = country;
                },
                getItemCode: (country) => country.code,
                getItemName: (country) => country.name,
                getItemIconUrl: (country) => country.flag,
                validator: (value) {
                  if (value == null) {
                    return context.translate("please_select_country_error");
                  }
                  return null;
                },
              ),
              CommonText.bodySmall(
                context.translate("change_your_country_note"),
                color: Color(0xff98989A),
              ),
            ],
          );
  }

  Center _errorState(GetCountriesState countriesState, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CommonText.bodyMedium(
              countriesState.errorMessage ??
                  context.translate("failed_to_load_countries"),
              textAlign: TextAlign.center,
              color: context.error,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                ref
                    .read(getCountriesNotifierProvider.notifier)
                    .fetchCountries();
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
