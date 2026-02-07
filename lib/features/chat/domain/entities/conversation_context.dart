class ConversationContext {
  final String type;
  final String referenceTitle;
  final String referenceImage;
  final DateTime? referenceDate;
  final Map<String, dynamic>? additionalData;

  ConversationContext({
    required this.type,
    required this.referenceTitle,
    required this.referenceImage,
    this.referenceDate,
    this.additionalData,
  });

  // Factory constructors for common context types
  factory ConversationContext.event({
    required String title,
    required String imageUrl,
    required DateTime eventDate,
    Map<String, dynamic>? eventData,
  }) {
    return ConversationContext(
      type: 'event_booking',
      referenceTitle: title,
      referenceImage: imageUrl,
      referenceDate: eventDate,
      additionalData: eventData,
    );
  }

  factory ConversationContext.location({
    required String name,
    required String imageUrl,
    DateTime? visitDate,
    Map<String, dynamic>? locationData,
  }) {
    return ConversationContext(
      type: 'location',
      referenceTitle: name,
      referenceImage: imageUrl,
      referenceDate: visitDate,
      additionalData: locationData,
    );
  }

  factory ConversationContext.post({
    required String postTitle,
    required String imageUrl,
    DateTime? postDate,
    Map<String, dynamic>? postData,
  }) {
    return ConversationContext(
      type: 'post_share',
      referenceTitle: postTitle,
      referenceImage: imageUrl,
      referenceDate: postDate,
      additionalData: postData,
    );
  }
}
