import 'package:equatable/equatable.dart';

enum Arcana { major, minor }

enum Suit { wands, cups, swords, pentacles }

class TarotCard extends Equatable {
  final String id;
  final String name;
  final Arcana arcana;
  final Suit? suit;
  final int number;
  final List<String> uprightKeywords;
  final List<String> reversedKeywords;
  final String uprightMeaning;
  final String reversedMeaning;
  final String imageAsset;

  const TarotCard({
    required this.id,
    required this.name,
    required this.arcana,
    required this.suit,
    required this.number,
    required this.uprightKeywords,
    required this.reversedKeywords,
    required this.uprightMeaning,
    required this.reversedMeaning,
    required this.imageAsset,
  });

  factory TarotCard.fromJson(Map<String, dynamic> json) => TarotCard(
    id: json['id'] as String,
    name: json['name'] as String,
    arcana: Arcana.values.byName(json['arcana'] as String),
    suit: json['suit'] == null
        ? null
        : Suit.values.byName(json['suit'] as String),
    number: json['number'] as int,
    uprightKeywords: List<String>.from(json['uprightKeywords'] as List),
    reversedKeywords: List<String>.from(json['reversedKeywords'] as List),
    uprightMeaning: json['uprightMeaning'] as String,
    reversedMeaning: json['reversedMeaning'] as String,
    imageAsset: json['imageAsset'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'arcana': arcana.name,
    'suit': suit?.name,
    'number': number,
    'uprightKeywords': uprightKeywords,
    'reversedKeywords': reversedKeywords,
    'uprightMeaning': uprightMeaning,
    'reversedMeaning': reversedMeaning,
    'imageAsset': imageAsset,
  };

  @override
  List<Object?> get props => [id, name, arcana, suit, number, imageAsset];
}
