class AppLocalImages {
// LOGO

  static const String gigaFaucetLogo = "assets/images/gigafaucet_logo.png";
  static const String gigaFaucetTextLogo =
      "assets/images/giga_faucet_text_logo.png";
  static const String gigaFaucetColorTextLogo =
      "assets/images/giga_faucet_color_text_logo.png";
  // icons
  static const String menuIconSvg = "assets/images/icons/menu.svg";
  static const String homeMenuIcon = "assets/images/icons/home_icon.svg";
  static const String walletIcon = "assets/images/icons/wallet_icon.svg";
  static const String accountIcon = "assets/images/icons/account_icon.svg";
  static const String chatIcon = "assets/images/icons/chat_icon.svg";
  static const String starNavIcon = "assets/images/icons/star_nav_icon.png";
  // Banner Images
  static const String bannerDesktop = "assets/images/bg/banner_web@2x.jpg";
  static const String bannerMobile = 'assets/images/bg/banner_mobile@2x.jpg';

  // coin Images
  static const String coin = "assets/images/rewards/coin@3x.png";
  static const String coinSvg = "assets/images/rewards/coin.svg";

  // Onboarding Images
  static const String onboardingBgMobile =
      "assets/images/bg/onboarding_bg_mobile@2x.jpg";
  static const String onboardingBgDesktop =
      "assets/images/bg/onboarding_bg_desktop@2x.jpg";

  // Home Images
  static const String homeBackgroundMobile =
      "assets/images/bg/home_background_mobile@2x.png";
  static const String homeBackgroundDesktop =
      "assets/images/bg/home_background_desktop@2x.png";

  static const String homeCoinBackgroundSection1Desktop =
      "assets/images/bg/home_coin_section_1_desktop@2x.png";
  static const String homeCoinBackgroundSection1Mobile =
      "assets/images/bg/home_coin_section_1_mobile@2x.png";

  static const String homeCoinBackgroundSection2Mobile =
      "assets/images/bg/home_coin_section_2_mobile@2x.png";

  static const String homeCoinBackgroundSection3Desktop =
      "assets/images/bg/home_coin_section_3_desktop@2x.png";
  // No Section 3 For Mobile

  static const String homeCoinBackgroundSection4Desktop =
      "assets/images/bg/home_coin_section_4_desktop@2x.png";
  static const String homeCoinBackgroundSection4Mobile =
      "assets/images/bg/home_coin_section_4_mobile@2x.png";

  // Girl Image
  static const String girlWholeBody = "assets/images/girl_whole_body.png";

  //Home
  static const String shopDiscount = 'assets/images/rewards/shop_discount.png';
  static const String shieldIcon = 'assets/images/rewards/shield_icon.png';
  static const String offerBoostReward =
      'assets/images/rewards/offer_boost_reward.png';

  static const String whale = 'assets/images/levels/whale.png';
  static const String eventPosterImage = 'assets/images/event_poster_image.png';
  static const String eventVisitShop = 'assets/images/event_visit_shop.png';
  static const String eventOurQuestToday =
      'assets/images/event_our_quest_today.png';
  static const String eventTreasureBox = 'assets/images/treasure_box.png';
  static const String eventDailyStreakBg = 'assets/images/trophy.png';

  // Home Features Section

  static const String features1 = 'assets/images/features/features_1.png';
  static const String features2 = 'assets/images/features/features_2.png';
  static const String features3 = 'assets/images/features/features_3.png';
  static const String features4 = 'assets/images/features/features_4.png';
  static const String features5 = 'assets/images/features/features_5.png';
  static const String features6 = 'assets/images/features/features_6.png';
  static const String features7 = 'assets/images/features/features_7.png';
  static const String features8 = 'assets/images/features/features_8.png';
  static const String features9 = 'assets/images/features/features_9.png';
  static const String features10 = 'assets/images/features/features_10.png';

  //Status Reward

  static const String dailySpin = "assets/images/rewards/daily_spin.png";
  static const String treasureChest =
      "assets/images/rewards/treasure_chest.png";
  static const String ptcAdDiscount =
      "assets/images/rewards/ptc_ad_discount.png";
  static const String statusRewardBg =
      "assets/images/rewards/status_rewards_bg.png";
  static const String bronze = "assets/images/rewards/bronze_level.png";
  static const String silver = "assets/images/rewards/sliver.png";
  static const String gold = "assets/images/rewards/gold.png";
  static const String diamond = "assets/images/rewards/diamond.png";
  static const String legend = "assets/images/rewards/legend.png";

  static String levelStatusImage(String status) {
    // return "assets/images/levels/$status.png";

    switch (status.toLowerCase()) {
      case "bronze":
        return AppLocalImages.bronze;
      case "silver":
        return AppLocalImages.silver;
      case "gold":
        return AppLocalImages.gold;
      case "diamond":
        return AppLocalImages.diamond;
      case "legend":
        return AppLocalImages.legend;
      default:
        return AppLocalImages.bronze;
    }
  }

  // Profile
  static const String location = "assets/images/icons/location.svg";
  static const String message = "assets/images/icons/message.svg";

  // Affiliate Program
  static const String facebookIcon = 'assets/images/icons/facebook.svg';
  static const String gmailIcon = 'assets/images/icons/gmail.svg';
  static const String whatsappIcon = 'assets/images/icons/whatsapp.svg';
  static const String linkedinIcon = 'assets/images/icons/linkedin.svg';
  static const String twitterIcon = 'assets/images/icons/twitter.svg';
  static const String telegramIcon = 'assets/images/icons/telegram.svg';
  static const String chatMessageIcon = 'assets/images/icons/chat_message.svg';
  static const String moneyBag = "assets/images/money_bag.png";
  static const String referralPerson = "assets/images/referral_person.png";
  static const String sandWatch = "assets/images/sand_watch.png";
  static const String week = "assets/images/week.png";

  //Tutorial

  static const String tutorialWelcome = 'assets/tutorial/welcome.png';
  static const String tutorialSpin = 'assets/tutorial/spin.png';
  static const String tutorialStreak = 'assets/tutorial/streak.webp';
  static const String tutorialPtc = 'assets/tutorial/ptc.jpg';
  static const String tutorialMissions = 'assets/tutorial/missions.png';
  static const String tutorialOffers = 'assets/tutorial/offers.png';
  static const String tutorialXp = 'assets/tutorial/xp.png';
  static const String tutorialWithdraw = 'assets/tutorial/withdraw.png';
  static const String tutorialReward = 'assets/tutorial/reward.png';

  // App Store Buttons
  static const String appStoreButton = 'assets/images/App Store.png';
  static const String googlePlayButton = 'assets/images/Google Play.png';

  // Withdrawal Earning Background
  static const String withdrawalEarningBg =
      "assets/images/bg/withdrawal_earning_bg@2x.png";

  // Others
  static const String warning = "assets/images/warning.png";
  static const String refreshCcw = "assets/images/icons/Refresh ccw.svg";
}
