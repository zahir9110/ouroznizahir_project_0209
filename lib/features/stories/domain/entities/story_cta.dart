import 'package:equatable/equatable.dart';

/// Call-to-Action d'une story
class StoryCTA extends Equatable {
  final StoryCTAType type;
  final String text;
  final String targetId;

  const StoryCTA({
    required this.type,
    required this.text,
    required this.targetId,
  });

  @override
  List<Object?> get props => [type, text, targetId];
}

/// Type de CTA
enum StoryCTAType {
  buyTicket,    // Acheter un billet
  chat,         // Ouvrir discussion
  viewEvent,    // Voir l'événement
  visitProfile, // Visiter profil
}

/// Extension pour conversion
extension StoryCTATypeX on StoryCTAType {
  String toFirestoreString() {
    switch (this) {
      case StoryCTAType.buyTicket:
        return 'buy_ticket';
      case StoryCTAType.chat:
        return 'chat';
      case StoryCTAType.viewEvent:
        return 'view_event';
      case StoryCTAType.visitProfile:
        return 'visit_profile';
    }
  }

  static StoryCTAType fromString(String value) {
    switch (value) {
      case 'buy_ticket':
        return StoryCTAType.buyTicket;
      case 'chat':
        return StoryCTAType.chat;
      case 'view_event':
        return StoryCTAType.viewEvent;
      case 'visit_profile':
        return StoryCTAType.visitProfile;
      default:
        return StoryCTAType.visitProfile;
    }
  }

  /// Texte par défaut selon le type
  String get defaultText {
    switch (this) {
      case StoryCTAType.buyTicket:
        return 'Acheter';
      case StoryCTAType.chat:
        return 'Discuter';
      case StoryCTAType.viewEvent:
        return 'Voir l\'événement';
      case StoryCTAType.visitProfile:
        return 'Visiter';
    }
  }
}
