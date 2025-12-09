import 'dart:developer';

import 'package:cointiply_app/core/common/common_text.dart';
import 'package:cointiply_app/core/common/dialog_bg_widget.dart';
import 'package:cointiply_app/core/common/table/common_table_widget.dart';
import 'package:cointiply_app/core/extensions/extensions.dart';
import 'package:cointiply_app/features/affiliate_program/data/models/request/referred_users_request.dart';
import 'package:cointiply_app/features/affiliate_program/presentation/providers/referral_link_provider.dart';
import 'package:cointiply_app/features/affiliate_program/presentation/providers/referred_users_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

showAffiliateProgramDialog(BuildContext context) {
  context.showAffiliateProgramPopup(
    barrierDismissible: false,
    child: const AffiliateProgramDialog(),
  );
}

class AffiliateProgramDialog extends ConsumerStatefulWidget {
  const AffiliateProgramDialog({super.key});

  @override
  ConsumerState<AffiliateProgramDialog> createState() =>
      _AffiliateProgramDialogState();
}

class _AffiliateProgramDialogState
    extends ConsumerState<AffiliateProgramDialog> {
  final socialIconList = [
    {
      'iconPath': 'assets/images/icons/facebook.svg',
      'name': 'facebook',
    },
    {
      'iconPath': 'assets/images/icons/gmail.svg',
      'name': 'gmail',
    },
    {
      'iconPath': 'assets/images/icons/whatsapp.svg',
      'name': 'whatsapp',
    },
    {
      'iconPath': 'assets/images/icons/linkedin.svg',
      'name': 'linkedin',
    },
    {
      'iconPath': 'assets/images/icons/twitter.svg',
      'name': 'twitter',
    },
    {
      'iconPath': 'assets/images/icons/telegram.svg',
      'name': 'telegram',
    },
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch referral link when dialog opens
      ref.read(referralLinkProvider.notifier).getReferralLink();

      // Fetch referred users list with initial parameters
      ref.read(referredUsersProvider.notifier).getReferredUsers(
            ReferredUsersRequest(
              page: 1,
              limit: 10,
            ),
          );
    });

    // Listen to referral link state changes
    // ref.listenManual<ReferralLinkState>(
    //   referralLinkProvider,
    //   (previous, next) {
    //     if (next.isSuccess && next.message != null) {
    //       // context.showSnackBar(
    //       //   message: next.message!,
    //       //   backgroundColor: context.colorScheme.primary,
    //       // );
    //     } else if (next.hasError && next.errorMessage != null) {
    //       // context.showSnackBar(
    //       //   message: next.errorMessage!,
    //       //   backgroundColor: context.error,
    //       // );
    //     }
    //   },
    // );
  }

  String _buildReferralUrl(String referralCode) {
    // For web platform
    if (kIsWeb) {
      final currentUrl = Uri.base;
      final isLocalhost = currentUrl.host.contains('localhost') ||
          currentUrl.host.contains('127.0.0.1');

      if (isLocalhost) {
        return 'localhost:8080/r/$referralCode';
      } else {
        return 'https://staging.gigafaucet.com/r/$referralCode';
      }
    }

    // For Android and iOS platforms
    return 'https://staging.gigafaucet.com/r/$referralCode';
  }

  @override
  Widget build(BuildContext context) {
    return DialogBgWidget(
        dialogHeight: context.isDesktop ? 700 : context.screenHeight * 0.8,
        body: _dialogBody(),
        title: context.translate("affiliate_program_title"));
  }

  Widget _dialogBody() {
    return SingleChildScrollView(
      padding: context.isDesktop
          ? const EdgeInsets.symmetric(horizontal: 24, vertical: 16)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.bodyMedium(
            context.translate("affiliate_program_description"),
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 24),
          _referralLinkSection(),
          const SizedBox(height: 15),
          _referralInfoSection(),
          const SizedBox(height: 15),
          _referralCoinList(),
        ],
      ),
    );
  }

  Container _referralLinkSection() {
    final referralLinkState = ref.watch(referralLinkProvider);
    final isLoading = referralLinkState.isLoading;
    final isError =
        referralLinkState.hasError && referralLinkState.errorMessage != null;
    final referralCode = referralLinkState.referralCode ?? '';
    final referralUrl =
        referralCode.isNotEmpty ? _buildReferralUrl(referralCode) : '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.5),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff333333)),
        image: DecorationImage(
          image: AssetImage('assets/images/trophy.png'),
          alignment: Alignment(0, 0),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16,
        children: [
          CommonText.headlineSmall(context.translate("referral_link"),
              fontWeight: FontWeight.w700, color: context.primary),
          Container(
            constraints: BoxConstraints(maxWidth: 380),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color(0xff1A1A1A),

                /// TODO: replace with design system color
                borderRadius: BorderRadius.circular(8)),
            child: isLoading
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : isError
                    ? CommonText.bodyMedium(
                        referralLinkState.errorMessage ?? 'Error',
                        fontWeight: FontWeight.w500,
                        color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: CommonText.bodyMedium(
                                referralUrl.isNotEmpty
                                    ? referralUrl
                                    : 'Loading...',
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          IconButton(
                              onPressed: referralUrl.isEmpty
                                  ? null
                                  : () {
                                      Clipboard.setData(
                                          ClipboardData(text: referralUrl));
                                      context.showSnackBar(
                                          message: context.translate(
                                              "referral_link_copied_message"));
                                    },
                              icon: Icon(
                                Icons.copy,
                                color: referralUrl.isEmpty
                                    ? Colors.grey
                                    : Colors.white,
                                size: 24,
                              ))
                        ],
                      ),
          ),
          CommonText.bodyMedium(
            context.translate("share"),
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          Wrap(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.max,
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                for (var socialIcon in socialIconList)
                  _socialIcon(
                      iconPath: socialIcon['iconPath']!,
                      onTap: () {
                        log('${socialIcon['name']} icon tapped');
                      }),
              ])
        ],
      ),
    );
  }

  Widget _socialIcon({required String iconPath, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14.5),
        alignment: Alignment.center,
        width: 44,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xff333333), width: 1),
          shape: BoxShape.circle,
          color: Color(0xff00131E).withAlpha((255 * 0.8).toInt()),
        ),
        child: SvgPicture.asset(
          iconPath,
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          width: 13,
          height: 13,
        ),
      ),
    );
  }

  Widget _referralInfoSection() {
    final isMobile = context.isMobile;

    return GridView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: isMobile ? 2 : 4),
      children: [
        _infoItem(
            assetPath: "assets/images/money_bag.png",
            value: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText.titleMedium("200",
                    fontWeight: FontWeight.w700, color: context.primary),
                const SizedBox(width: 4),
                Image.asset(
                  "assets/images/rewards/coin.png",
                  height: 16,
                  width: 16,
                ),
              ],
            ),
            label: context.translate("referral_earnings")),
        _infoItem(
            assetPath: "assets/images/referral_person.png",
            value: CommonText.titleMedium("5",
                fontWeight: FontWeight.w700, color: context.primary),
            label: context.translate("referral_users")),
        _infoItem(
            assetPath: "assets/images/sand_watch.png",
            value: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText.titleMedium("200",
                    fontWeight: FontWeight.w700, color: context.primary),
                const SizedBox(width: 4),
                Image.asset(
                  "assets/images/rewards/coin.png",
                  height: 16,
                  width: 16,
                ),
              ],
            ),
            label: context.translate("pending_earnings")),
        _infoItem(
            assetPath: "assets/images/week.png",
            value: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CommonText.titleMedium("200",
                    fontWeight: FontWeight.w700, color: context.primary),
                const SizedBox(width: 4),
                Image.asset(
                  "assets/images/rewards/coin.png",
                  height: 16,
                  width: 16,
                ),
              ],
            ),
            label: context.translate("active_this_week")),
      ],
    );
  }

  Widget _infoItem(
      {required String assetPath,
      required Widget value,
      required String label}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff00131E).withAlpha((255 * 0.8).toInt()),
        border: Border.all(color: Color(0xff333333)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            assetPath,
            height: 37,
          ),
          SizedBox(height: 10),
          value,
          const SizedBox(height: 8),
          CommonText.bodyMedium(
            label,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  _referralCoinList() {
    final referredUsersState = ref.watch(referredUsersProvider);
    final isLoading = referredUsersState.isLoading;
    final hasError = referredUsersState.hasError;
    final isEmpty = referredUsersState.isEmpty;
    final users = referredUsersState.users;
    final pagination = referredUsersState.pagination;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff333333)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.headlineSmall(
            context.translate("referral"),
            color: context.primary,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 16),
          if (isLoading)
            _buildSkeletonLoader()
          else if (hasError)
            _buildErrorWidget(
                referredUsersState.errorMessage ?? 'Failed to load users')
          else if (isEmpty)
            _buildEmptyWidget()
          else
            CommonTableWidget(
              headers: [
                context.translate("date"),
                context.translate("username"),
                context.translate("coins_earn")
              ],
              values: users.map((user) {
                final date = user.referralDate != null
                    ? DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(user.referralDate!))
                    : 'N/A';
                final name = user.name ?? 'Unknown';
                final earned = user.totalEarnedFromReferee?.toString() ?? '0';
                return [date, name, earned];
              }).toList(),
              total: pagination?.total ?? 0,
              page: pagination?.currentPage ?? 1,
              limit: pagination?.limit ?? 10,
              totalPages: pagination?.totalPages ?? 1,
              changePage: (page) {
                ref.read(referredUsersProvider.notifier).changePage(page);
              },
              changeLimit: (limit) {
                ref.read(referredUsersProvider.notifier).changeLimit(limit);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(child: Container(height: 16, color: Colors.white)),
                const SizedBox(width: 16),
                Expanded(child: Container(height: 16, color: Colors.white)),
                const SizedBox(width: 16),
                Expanded(child: Container(height: 16, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: context.error,
            ),
            const SizedBox(height: 16),
            CommonText.bodyLarge(
              message,
              color: context.error,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(referredUsersProvider.notifier).refreshData();
              },
              child: CommonText.bodyMedium('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 48,
              color: context.onSurface.withAlpha(128),
            ),
            const SizedBox(height: 16),
            CommonText.bodyLarge(
              'No referred users yet',
              color: context.onSurface.withAlpha(179),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CommonText.bodyMedium(
              'Share your referral link to start earning!',
              color: context.onSurface.withAlpha(128),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
