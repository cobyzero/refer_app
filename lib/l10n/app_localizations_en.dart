// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeBack => 'Welcome back.';

  @override
  String get home => 'Home';

  @override
  String get welcomeSubtitle =>
      'Your referrals and rewards are just a sign-in away.';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'name@email.com';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => '........';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get orContinueWith => 'OR CONTINUE WITH';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get settings => 'Settings';

  @override
  String get account => 'ACCOUNT';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get preferences => 'PREFERENCES';

  @override
  String get orderHistory => 'Order History';

  @override
  String get notifications => 'Notifications';

  @override
  String get language => 'Language';

  @override
  String get security => 'SECURITY';

  @override
  String get changePassword => 'Change Password';

  @override
  String get biometricLogin => 'Biometric Login';

  @override
  String get supportLegal => 'SUPPORT & LEGAL';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get signOut => 'Sign Out';

  @override
  String get version => 'Version';

  @override
  String get viewProfile => 'View Profile';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get signupSubtitle => 'Create your account and start referring.';

  @override
  String get fullName => 'Full Name';

  @override
  String get fullNameHint => 'Elias Thorne';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String acceptTerms(String terms, String privacy) {
    return 'I accept the $terms and $privacy.';
  }

  @override
  String get keepUpdated =>
      'Keep me updated with seasonal collections and exclusive roastery news.';

  @override
  String get accountCreatedSuccess => 'Account created successfully!';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign In';

  @override
  String get createAccount => 'Create Account';

  @override
  String get appName => 'Referral App';

  @override
  String goodMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String get homeSubtitle => 'Your daily brew is ready to be discovered.';

  @override
  String starsUntilNextReward(int count) {
    return '$count more stars until your next free artisanal brew';
  }

  @override
  String get seasonalBrews => 'Seasonal Brews';

  @override
  String get viewMenu => 'View menu';

  @override
  String get noSeasonalBrews => 'No seasonal brews available';

  @override
  String get quickOrder => 'Quick Order';

  @override
  String get categories => 'Categories';

  @override
  String get coffee => 'Coffee';

  @override
  String get tea => 'Tea';

  @override
  String get bakery => 'Bakery';

  @override
  String get merchandise => 'Merchandise';

  @override
  String get productDetailsTitle => 'The Sensory Sommelier';

  @override
  String get selectSize => 'SELECT SIZE';

  @override
  String get milkChoice => 'MILK CHOICE';

  @override
  String get enhancements => 'ENHANCEMENTS';

  @override
  String get extraEspresso => 'Extra Espresso Shot';

  @override
  String get sweetener => 'Sweetener';

  @override
  String get addToOrder => 'Add to Order';

  @override
  String get calories => 'CALORIES';

  @override
  String get caffeine => 'CAFFEINE';

  @override
  String get tall => 'Tall';

  @override
  String get grande => 'Grande';

  @override
  String get venti => 'Venti';

  @override
  String get wholeMilk => 'Whole Milk';

  @override
  String get oatMilk => 'Oat Milk';

  @override
  String get almondMilk => 'Almond Milk';

  @override
  String get sensoryRoastSeries => 'Sensory Roast Series';

  @override
  String get searchHint => 'Search for coffee, tea, or treats...';

  @override
  String get orders => 'Orders';

  @override
  String get stars => 'Stars';

  @override
  String get checkout => 'Checkout';

  @override
  String get pickupLocation => 'Pickup Location';

  @override
  String get pickupTime => 'Pickup Time';

  @override
  String get yourOrder => 'Your Order';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get serviceFee => 'Service Fee';

  @override
  String get total => 'Total';

  @override
  String get placeOrder => 'Place Order';

  @override
  String get devPaymentTitle => 'Development mode';

  @override
  String devPaymentMessage(Object amount) {
    return 'You\'re in DEV: card payment will be skipped and the order will be completed directly for $amount.';
  }

  @override
  String get devPaymentConfirm => 'Continue without paying';

  @override
  String get devPaymentCancel => 'Cancel';

  @override
  String get orderPlaced => 'Order Placed!';

  @override
  String get orderSuccessDetail =>
      'Your artisanal brew will be ready in 10-15 minutes.';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get selectFutureTime => 'Please select a time in the future';

  @override
  String get orderCreateError =>
      'We couldn\'t create your order. Please try again.';

  @override
  String get orderConfirmError =>
      'Your payment was received but we couldn\'t confirm your order. Please contact support.';

  @override
  String get errorLoadingOrders => 'Error loading orders';

  @override
  String get noOrdersFound => 'No orders found';

  @override
  String get thisMonth => 'THIS MONTH';

  @override
  String get yourCollection => 'YOUR COLLECTION';

  @override
  String get pastExperiences => 'Past\nexperiences';

  @override
  String get reorder => 'Reorder';

  @override
  String get statusOrdered => 'ORDERED';

  @override
  String get statusPreparing => 'PREPARING';

  @override
  String get statusReady => 'READY FOR PICKUP';

  @override
  String get statusCompleted => 'COMPLETED';

  @override
  String get statusCancelled => 'CANCELLED';

  @override
  String get viewFullMonth => 'View full month';

  @override
  String get yourRituals => 'Your Rituals';

  @override
  String get ritualsSubtitle =>
      'Tracking your current cravings and past favorites from the roastery.';

  @override
  String get activeOrders => 'Active Orders';

  @override
  String activeCount(int count) {
    return '$count active';
  }

  @override
  String get noHistoryYet => 'No history yet';

  @override
  String get viewFullArchive => 'View full archive';

  @override
  String orderNumber(String number) {
    return 'Order #$number';
  }

  @override
  String get statusBrewing => 'BREWING';

  @override
  String get estimatedPickup => 'Estimated pickup';

  @override
  String get estimatedPickupDetail =>
      'Approximately 6-8 minutes at the 5th Ave Roastery.';

  @override
  String get viewDirections => 'View Directions';

  @override
  String get reorderAll => 'Reorder All';

  @override
  String get currentBalance => 'CURRENT BALANCE';

  @override
  String get starsRewards => 'Stars Rewards';

  @override
  String get redeemYourStars => 'Redeem your Stars';

  @override
  String get earningPerks => 'Earning & Perks';

  @override
  String starsRemaining(int count, String reward) {
    return '$count more Stars until your $reward';
  }

  @override
  String get recentProducts => 'Recent Products';

  @override
  String get insufficientStars =>
      'You don\'t have enough stars for this reward.';

  @override
  String get redeemReward => 'Redeem Reward';

  @override
  String confirmRedemption(int stars) {
    return 'Are you sure you want to spend $stars stars on this reward?';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get currentPasswordHint => 'Enter your current password';

  @override
  String get newPassword => 'New Password';

  @override
  String get newPasswordHint => 'Enter your new password (min. 6 chars)';

  @override
  String get passwordChangedSuccessfully => 'Password changed successfully!';

  @override
  String get errorChangingPassword =>
      'Error changing password. Please check your credentials.';

  @override
  String get go_to_checkout => 'Go to checkout';

  @override
  String get reviewSelection => 'Review Selection';

  @override
  String itemsCount(int count) {
    return '$count items';
  }

  @override
  String get promoCode => 'PROMO CODE';

  @override
  String get enterCode => 'Enter code';

  @override
  String get apply => 'Apply';

  @override
  String get estimatedTax => 'Estimated Tax';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get cartInfoMessage =>
      'Items are prepared fresh upon your arrival. Enjoy our sensory experience at its peak by arriving within 10 minutes of your pick-up time.';

  @override
  String rewardClaim(String title) {
    return 'Reward Claim: $title';
  }

  @override
  String get claimReward => 'Claim Reward';

  @override
  String earningStars(int stars) {
    return 'You are earning $stars stars with this order!';
  }

  @override
  String get orderStatusTitle => 'Order Status';

  @override
  String get orderIsReady => 'Your order is ready!';

  @override
  String get pickupInstructions =>
      'Go directly to the pickup counter to collect your order. Enjoy!';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get birthDate => 'Birth Date';

  @override
  String get tapToUpdateImage => 'Tap to update image';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get errorUpdatingProfile => 'Error updating profile';

  @override
  String get orderDetails => 'Order Details';

  @override
  String get orderDate => 'Date';

  @override
  String get searchFAQ => 'Search FAQs...';

  @override
  String get faqCategoryGeneral => 'General';

  @override
  String get faqCategoryPayments => 'Payments';

  @override
  String get faqCategoryOrders => 'Orders';

  @override
  String get faqCategoryAccount => 'Account';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get contactUsEmail => 'Email us';

  @override
  String get contactUsPhone => 'Call us';

  @override
  String get faqQ1 => 'How do I earn stars?';

  @override
  String get faqA1 =>
      'You earn stars with every purchase you make. For every dollar spent, you get 1 star. Redeem stars for free drinks and rewards!';

  @override
  String get faqQ2 => 'How do I collect my order?';

  @override
  String get faqA2 =>
      'Once you place an order, you can check its status on the Orders tab. When its status is READY, simply head to the counter and show your order number.';

  @override
  String get faqQ3 => 'What payment methods are supported?';

  @override
  String get faqA3 =>
      'We accept major credit and debit cards, Apple Pay, and digital wallet payments directly in the checkout view.';

  @override
  String get faqQ4 => 'How do I change my password?';

  @override
  String get faqA4 =>
      'Go to settings, and under Security, tap Change Password. Enter your current password and your new password to update it.';

  @override
  String get noResults => 'No results found';

  @override
  String get all => 'All';

  @override
  String get searchSubtitle => 'Curated selections for every palate.';

  @override
  String noProductsFound(String query) {
    return 'No products found for \"$query\"';
  }

  @override
  String get failedToLoadCategories => 'Failed to load categories';

  @override
  String get noCategoriesFound => 'No categories found';

  @override
  String get explore => 'EXPLORE';

  @override
  String get discoverPremiumSelection => 'Discover our premium selection';

  @override
  String get unclaimedRewards => 'Your Unclaimed Rewards';

  @override
  String get tapToClaim => 'Tap to claim';

  @override
  String get stayTunedPerks => 'Stay tuned for upcoming perks!';

  @override
  String get viewHistory => 'View History';

  @override
  String redeemingReward(String title) {
    return 'Redeeming $title...';
  }

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get noRecentActivity => 'No recent activity';

  @override
  String get starsHistory => 'Stars History';

  @override
  String get change => 'Change';

  @override
  String get selectPickupPoint => 'Select Pickup Point';

  @override
  String get asap => 'As soon as possible';

  @override
  String get scheduleLater => 'Schedule for later';

  @override
  String get selectSpecificTime => 'Select a specific time';

  @override
  String get stripePayment => 'Card';

  @override
  String get safeSecure => 'Safe & Secure';

  @override
  String get underMaintenance => 'Under Maintenance';

  @override
  String get maintenanceDescription =>
      'We\'re currently updating our roastery systems to serve you better. We\'ll be back shortly.';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get estimatedTime => 'Estimated time: ~30 mins';

  @override
  String get pleaseAcceptTerms => 'Please accept the Terms and Privacy Policy';

  @override
  String get recoveryCodeSent => 'Recovery code sent successfully';

  @override
  String get passwordResetSuccess =>
      'Password reset successfully. Please log in.';

  @override
  String productAddedToCart(String product) {
    return '$product added to cart!';
  }

  @override
  String get enterValidEmail => 'Enter a valid email';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get enterFullName => 'Enter your full name';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get enter6DigitCode => 'Enter the 6-digit code';

  @override
  String get requiredField => 'Required field';

  @override
  String get min6Chars => 'Min 6 characters';

  @override
  String get minimum6Chars => 'Minimum 6 characters';

  @override
  String get repeatPassword => 'Repeat password';

  @override
  String get verificationCode => 'Verification code';

  @override
  String get enter6DigitCodeHint => 'Enter 6-digit code';

  @override
  String get recoverPassword => 'Recover password';

  @override
  String get recoverPasswordSubtitle =>
      'Enter your email address to receive a 6-digit verification code to reset your password.';

  @override
  String resetPasswordSubtitle(String email) {
    return 'Enter the 6-digit recovery code sent to $email and choose your new password.';
  }

  @override
  String get sendCode => 'Send code';

  @override
  String get resetPassword => 'Reset password';

  @override
  String agreeTermsPrivacy(String terms, String privacy) {
    return 'By signing in you agree to our $terms and $privacy.';
  }

  @override
  String get back => 'Back';

  @override
  String get updateRequiredTitle => 'Update required';

  @override
  String updateRequiredMessage(String version) {
    return 'This version is no longer supported. Update to version $version or later to continue.';
  }

  @override
  String currentVersion(String version) {
    return 'Current version: $version';
  }

  @override
  String get updateAvailableTitle => 'Update available';

  @override
  String updateAvailableMessage(String version) {
    return 'Version $version is available with improvements. Do you want to update now?';
  }

  @override
  String get updateNow => 'Update now';

  @override
  String get remindLater => 'Later';

  @override
  String get couldNotOpenStore => 'Couldn\'t open the app store';

  @override
  String get couldNotOpenLink => 'Couldn\'t open the link';

  @override
  String get verifyEmailTitle => 'Verify your email';

  @override
  String verifyEmailSubtitle(String email) {
    return 'Enter the 6-digit code we sent to $email.';
  }

  @override
  String get verifyEmailAction => 'Verify email';

  @override
  String get emailVerifiedSuccess => 'Email verified! You are signed in.';

  @override
  String get resendCode => 'Resend code';

  @override
  String resendCodeCooldown(int seconds) {
    return 'Resend in ${seconds}s';
  }
}
