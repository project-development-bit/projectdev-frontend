import 'package:cointiply_app/features/wallet/domain/entity/withdrawal_option.dart';
import 'package:flutter/material.dart';
import 'package:cointiply_app/core/core.dart';

class WithdrawalEarningMethodsWidget extends StatelessWidget {
  final List<WithdrawalOption> methods;
  final Function(WithdrawalOption option) onSelect;
  final bool isLoading;

  const WithdrawalEarningMethodsWidget({
    super.key,
    required this.methods,
    required this.onSelect,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 11 : 22.5, vertical: isMobile ? 21 : 22.5),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1.4, color: const Color(0xFF333333)),
        image: const DecorationImage(
          image: AssetImage("assets/images/bg/withdrawal_earning_bg@2x.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: methods.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 2 : 2,
                mainAxisSpacing: isMobile ? 11 : 20,
                crossAxisSpacing: isMobile ? 15 : 20,
                childAspectRatio: isMobile
                    ? 0.75
                    : isTablet
                        ? 1.9
                        : 2.3,
              ),
              itemBuilder: (_, index) {
                final item = methods[index];

                return WithdrawalCard(
                  item: item,
                  onTap: () => onSelect(item),
                );
              },
            ),
    );
  }
}

class WithdrawalCard extends StatefulWidget {
  final WithdrawalOption item;
  final VoidCallback onTap;

  const WithdrawalCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<WithdrawalCard> createState() => _WithdrawalCardState();
}

class _WithdrawalCardState extends State<WithdrawalCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final translation = AppLocalizations.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    const Color(0xFF333333), // // TODO: use Color From Scheme
              ),
              color: const Color(0xFF00131E)
                  .withValues(alpha: 0.5), // TODO: use Color From Scheme
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonText.titleSmall(
                  widget.item.name,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: 9),
                CommonImage(
                    imageUrl: widget.item.iconUrl, width: 45, height: 45),
                const SizedBox(height: 9),
                CommonText.bodySmall(
                  "Minimum ${widget.item.minAmountCoins.toString()} coins. ${widget.item.feeCoins > 0 ? "Has Fees" : "No Fees"}",
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  color: const Color(0xFF98989A), // TODO: use Color From Scheme
                ),
              ],
            ),
          ),
          if (_isHovering)
            Positioned.fill(
              child: Center(
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: TweenAnimationBuilder(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween<double>(
                      begin: 0.5,
                      end: 1.0,
                    ),
                    builder: (context, double scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: CommonText.bodySmall(
                        translation
                                ?.translate('withdraw_button_text')
                                .replaceFirst("{coinName}", widget.item.name) ??
                            "Withdraw ${widget.item.name.toUpperCase()}",
                        color: const Color(
                            0xFF141414), // TODO: use Color From Scheme
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
