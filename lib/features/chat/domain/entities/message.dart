enum MessageType {
  text,
  image,
  audio,
  postShare,
  location,
}

enum MessageStatus {
  sent,
  delivered,
  read,
}

class MessageContent {
  final String? text;
  final String? url;
  final int? duration;
  final dynamic postPreview;
  final double? latitude;
  final double? longitude;
  final String? locationName;

  MessageContent({
    this.text,
    this.url,
    this.duration,
    this.postPreview,
    this.latitude,
    this.longitude,
    this.locationName,
  });
}

class EphemeralSettings {
  final bool enabled;
  final int durationHours;

  EphemeralSettings({
    required this.enabled,
    required this.durationHours,
  });
}

class Message {
  final String senderId;
  final MessageType type;
  final MessageContent content;
  final DateTime timestamp;
  final MessageStatus status;
  final EphemeralSettings? ephemeral;

  Message({
    required this.senderId,
    required this.type,
    required this.content,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.ephemeral,
  });
}
