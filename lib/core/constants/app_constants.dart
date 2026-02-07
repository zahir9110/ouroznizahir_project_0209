
class AppConstants {
  static const String appName = 'Benin Experience';
  static const String appVersion = '1.0.0';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String postsCollection = 'feed_posts';
  static const String storiesCollection = 'stories';
  static const String conversationsCollection = 'conversations';
  static const String verificationRequestsCollection = 'verification_requests';
  static const String eventsCollection = 'events';
  static const String bookingsCollection = 'bookings';
  
  // Storage Paths
  static const String userAvatarsPath = 'users/avatars';
  static const String postImagesPath = 'posts/images';
  static const String storyMediaPath = 'stories/media';
  static const String verificationDocsPath = 'verification/documents';
  
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
