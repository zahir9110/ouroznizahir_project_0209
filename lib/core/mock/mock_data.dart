import '../models/event.dart';

class MockData {
  static List<String> categories = [
    "Tout", "Musique", "Gastronomie", "Histoire", "Nature"
  ];

  static List<Event> events = [
    Event(
      id: "1",
      title: "Fête de l'Indépendance - Place des Martyrs",
      location: "Cotonou, Bénin",
      date: "01 Août • 18h00",
      imageUrl: "https://images.unsplash.com/photo-1493225255756-d9584f8606e9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      price: 0.0,
      likes: 1240,
      category: "Musique"
    ),
    Event(
      id: "2",
      title: "Cours de cuisine au Feu des Dieux",
      location: "Ouidah, Bénin",
      date: "15 Août • 12h00",
      imageUrl: "https://images.unsplash.com/photo-1466978913421-dad2ebd01d17?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      price: 15000,
      likes: 850,
      category: "Gastronomie"
    ),
    Event(
      id: "3",
      title: "Visite guidée des Palais Rois d'Abomey",
      location: "Abomey, Bénin",
      date: "02 Sept • 09h00",
      imageUrl: "https://images.unsplash.com/photo-1548013146-72479768bada?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
      price: 10000,
      likes: 3200,
      category: "Histoire"
    ),
  ];
}
