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
  static const String coin = "assets/images/rewards/coin@2x.png";
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
  // static const String shieldIcon = 'assets/images/rewards/shield_icon.png';
  static const String offerBoostReward =
      'assets/images/rewards/offer_boast@3x.png';

  static const String whale = 'assets/images/levels/whale.png';
  static const String eventPosterImage =
      'assets/images/event_poster_image@2x.jpg';
  static const String eventVisitShop = 'assets/images/event_visit_shop@2x.jpg';
  static const String eventOurQuestToday =
      'assets/images/event_our_quest_today@2x.jpg';
  static const String eventTreasureBox = 'assets/images/treasure_box@2x.png';
  static const String eventDailyStreakBg = 'assets/images/trophy.png';

  // Home Features Section

  static const String features1 = 'assets/images/features/claim_faucet@2x.jpg';
  static const String features2 =
      'assets/images/features/treasure_chest@2x.jpg';
  static const String features3 = 'assets/images/features/fortune_wheel@2x.png';
  static const String features4 = 'assets/images/features/surveys@2x.jpg';
  static const String features5 = 'assets/images/features/exchanger@2x.jpg';
  static const String features6 = 'assets/images/features/play_game_app@2x.jpg';
  static const String features7 = 'assets/images/features/watch_videos@2x.jpg';
  static const String features8 =
      'assets/images/features/visit_websites@2x.jpg';
  static const String features9 =
      'assets/images/features/pirate_treasure_hunt@2x.jpg';
  static const String features10 = 'assets/images/features/quest@2x.jpg';

  //Status Reward

  static const String dailySpin = "assets/images/rewards/daily_spin@3x.png";
  static const String treasureChest =
      "assets/images/rewards/treasure_chest@3x.png";
  static const String ptcAdDiscount =
      "assets/images/rewards/ptc_ad_discount@2x.png";
  static const String statusRewardBg =
      "assets/images/rewards/status_rewards_bg.png";
  static const String bronze = "assets/images/rewards/bronze.webp";
  static const String silver = "assets/images/rewards/silver.webp";
  static const String gold = "assets/images/rewards/gold.webp";
  static const String diamond = "assets/images/rewards/diamond.webp";
  static const String legend = "assets/images/rewards/legend.svg";
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
  static const String moneyBag = "assets/images/money_bag@2x.png";
  static const String referralPerson = "assets/images/referral_users@2x.png";
  static const String sandWatch = "assets/images/pending_earnings@2x.png";
  static const String week = "assets/images/weekly@2x.png";

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

  // Fortune Wheel
  static const String fortuneWheelGirl = "assets/images/fortune_wheel_girl.png";
  static const String wheelBanner = "assets/images/wheel_banner.png";
  static const String wheelIndicator = "assets/images/wheel_indicator.png";
  static const String spinningInnerWheel =
      "assets/images/spinning_inner_wheel.png";
  static const String outerWheel = "assets/images/outer_wheel.png";
  static const String wheelCenterPath = "assets/images/wheel_center_path.png";
  static const String spinNotRemainBg = "assets/images/spin_not_remain_bg.png";
  static const String spinNotRemainBgMobile =
      "assets/images/spin_not_remain_bg_mobile.png";
  static const String spinWheelIcon = "assets/images/spin_wheel_icon.png";
  static const String outOfSpins = "assets/images/out_of_spins.png";

  // Faucet Images
  static const String nextFaucetBg = "assets/images/bg/next_faucet_bg.png";

  // Logo Images
  static const String googleLogo = "assets/images/logos/google.svg";
  static const String facebookLogo = "assets/images/logos/facebook.svg";

  static const String splashLogo = "assets/images/giga_faucet_text_logo.png";
  static const String splashBackground = "assets/images/splash_background.png";
  static const String splashBackgroundMobile =
      "assets/images/splash_background_mobile.png";
  static const String twoFABackground = "assets/images/bg/2fa_background.png";

  static const String fortuneWheelGirlCong =
      'assets/images/fortune_wheel_girl_cong.png';
  static const String congratsLabel = 'assets/images/congrats_label.png';
  static const String successSpingDialogBg =
      'assets/images/success_spin_dialog_bg.png';
  static const String successSpingDialogBgMobile =
      'assets/images/success_spin_dialog_bg_mobile.png';

  static String homeCoinBackgroundSection2Desktop =
      "assets/images/bg/home_coin_section_2_desktop@2x.png";

  // Pirate Treasure Hunt
  static const String pirateTreasureHuntProcessBg =
      "assets/images/pirate_treasure_hunt/hunt_progress_bg.png";
  static const String pirateTreasureHuntMap =
      "assets/images/pirate_treasure_hunt/treasure-map@2x.png";
  static const String pirateTreasureHuntMapRoute =
      "assets/images/pirate_treasure_hunt/map-route.png";
  static const String pirateTreasureHuntMapGirl =
      "assets/images/pirate_treasure_hunt/map-items/gigafaucet-girl.png";
  static const String questionMark =
      "assets/images/pirate_treasure_hunt/map-items/question-mark.svg";

  static const String treasureFoundBg =
      "assets/images/pirate_treasure_hunt/treasure-found-bg.png";
  static const String treasureFoundTitle =
      "assets/images/pirate_treasure_hunt/treasure-found-title@2x.png";
  static const String treasureFoundBoard =
      "assets/images/pirate_treasure_hunt/treasure-board@2x.png";
  static const String island1 =
      'assets/images/pirate_treasure_hunt/islands/island1.svg';
  static const String island2 =
      'assets/images/pirate_treasure_hunt/islands/treasure-ship.svg';
  static const String island3 =
      'assets/images/pirate_treasure_hunt/islands/island3.svg';
  static const String island4 =
      "assets/images/pirate_treasure_hunt/islands/island4.png";
  static const String island5 =
      'assets/images/pirate_treasure_hunt/islands/island5.svg';
  static const String island6 =
      'assets/images/pirate_treasure_hunt/islands/island6.svg';
  static const String island7 =
      'assets/images/pirate_treasure_hunt/islands/island7.svg';
  static const String island8 =
      'assets/images/pirate_treasure_hunt/islands/island8.svg';
}
