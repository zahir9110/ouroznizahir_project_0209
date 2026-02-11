
class AppConstants {
  static const String appName = 'bōken';
  static const String appVersion = '1.0.0';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String postsCollection = 'feed_posts';
  static const String storiesCollection = 'stories';
  static const String conversationsCollection = 'conversations';
  static const String verificationRequestsCollection = 'verification_requests';
  static const String eventsCollection = 'events';
  static const String bookingsCollection = 'bookings';
  static const String organizersCollection = 'organizers';
  static const String offersCollection = 'offers';
  static const String reviewsCollection = 'reviews';
  static const String boostCampaignsCollection = 'boost_campaigns';
  static const String payoutsCollection = 'payouts';
  
  // Storage Paths
  static const String userAvatarsPath = 'users/avatars';
  static const String postImagesPath = 'posts/images';
  static const String storyMediaPath = 'stories/media';
  static const String verificationDocsPath = 'verification/documents';
  static const String offerMediaPath = 'offers/media';
  static const String reviewPhotosPath = 'reviews/photos';
  
  // Business Constants
  static const double defaultCommissionRate = 8.0; // 8%
  static const int minPayoutAmount = 5000; // XOF
  static const String defaultCurrency = 'XOF';
  
  // Boost Pricing (XOF)
  static const int boostFeedPrice7Days = 2000;
  static const int boostGuidePrice30Days = 5000;
  static const int boostTopExperiencePrice = 10000;
  
  // Subscription Pricing (XOF/month)
  static const int subscriptionPlusPrice = 15000;
  static const double subscriptionPlusCommission = 5.0; // 5%
  
  // Durations
  static const Duration storyDurationStandard = Duration(hours: 24);
  static const Duration storyDurationPro = Duration(hours: 72);
  static const Duration ephemeralMessageDefault = Duration(hours: 24);
  
  // Limits
  static const int maxStoryPhotos = 10;
  static const int maxPostPhotos = 10;
  static const int maxVerificationPhotos = 5;
  static const int maxCaptionLength = 2200;
  static const int maxBioLength = 150;
  
  // Map Defaults
  static const double defaultMapZoom = 13.0;
  static const double defaultLatitude = 6.3667;  // Cotonou
  static const double defaultLongitude = 2.4333;
}
