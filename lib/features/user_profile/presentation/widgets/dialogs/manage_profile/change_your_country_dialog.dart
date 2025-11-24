import 'package:cointiply_app/core/common/common_button.dart';
import 'package:cointiply_app/core/common/common_dropdown_field.dart';
import 'package:cointiply_app/core/common/common_image_widget.dart';
import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/features/user_profile/domain/entities/country.dart';
import 'package:cointiply_app/features/user_profile/presentation/providers/get_countries_state.dart';
import 'package:cointiply_app/features/user_profile/presentation/widgets/dialogs/dialog_bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showChangeCountryDialog(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: colorScheme.scrim.withValues(alpha: 0.6),
    builder: (context) => const ChangeCountryDialog(),
  );
}

class ChangeCountryDialog extends ConsumerStatefulWidget {
  const ChangeCountryDialog({super.key});

  @override
  ConsumerState<ChangeCountryDialog> createState() =>
      _ChangeCountryDialogState();
}

class _ChangeCountryDialogState extends ConsumerState<ChangeCountryDialog> {
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    // Fetch countries when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(getCountriesNotifierProvider.notifier).fetchCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DialogBgWidget(
      dialogHeight: 400,
      body: _manageDialogBody(context),
      title: context.translate("change_your_country_title"),
    );
  }

  Widget _manageDialogBody(BuildContext context) {
    final countriesState = ref.watch(getCountriesNotifierProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
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

          CommonButton(
            text: context.translate("change_your_country_btn_text"),
            backgroundColor: const Color(0xff333333),
            onPressed: _selectedCountry != null ? () {
              
            } : null,
          ),
        ],
      ),
    );
  }

  Widget _dataState(GetCountriesState countriesState, BuildContext context) {
    return Column(
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
              child: CommonText.bodyMedium(
                context.translate("your_country"),
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              flex: 2,
              child: CommonDropdownFieldWithIcon<Country>(
                items: countriesState.countries!,
                value: _selectedCountry,
                onChanged: (country) {
                  setState(() {
                    _selectedCountry = country;
                  });
                },
                hint: context.translate("select_your_country_hint"),
                getItemCode: (country) => country.code,
                getItemName: (country) => country.name,
                getItemIcon: (country) {
                  final flag = country.flag;
                  return CommonImage(
                    imageUrl: flag,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                  );
                },
                validator: (value) {
                  if (value == null) {
                    return context.translate("please_select_country_error");
                  }
                  return null;
                },
              ),
            ),
          ],
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
