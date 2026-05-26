class AcStrings {
  // Replace this with your actual Firebase Auth UID before running.
  // Find it in Firebase Console → Authentication → your account row.
  static const String adminUid = 'FLfAWXAXTvbdF2mHWdoTx129gM63';

  // The appId that matches the 'appId' field in Firestore entitlements docs.
  // Must exactly match what iron_g writes. Currently: 'ironm'
  static const String targetAppId = 'ironm';

  static const String appName     = 'IronControl';
  static const String appTagline  = 'Subscription Admin Panel';
  static const String unauthorized = 'Unauthorized. This account does not have admin access.';
  static const String firebaseUnavailable = 'Firebase unavailable. Check your connection.';
  static const String noSubscribers = 'No subscribers found.';
  static const String killSwitchFailed = 'Failed to update kill switch.';
  static const String notesSaved  = 'Notes saved.';
  static const String extended30  = 'Subscription extended by 30 days.';
  static const String extended90  = 'Subscription extended by 90 days.';
  static const String suspended   = 'Subscriber suspended.';
  static const String reactivated = 'Subscriber reactivated.';
}
