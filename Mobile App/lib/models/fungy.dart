class Fungy {
  final int id;
  final String name;
  final double probability;
  final bool venomous;
  final String fungyImageUrl;
  final String fungyDescription;

  Fungy({
    required this.id,
    required this.name,
    required this.probability,
    required this.venomous,
    required this.fungyImageUrl,
    required this.fungyDescription,
  });

  factory Fungy.fromJson(Map<String, dynamic> json) {
    return Fungy(
      id: json['id'] as int,
      name: json['name'] as String,
      probability: (json['probability'] as num).toDouble(),
      venomous: json['venomous'] as bool,
      fungyImageUrl: json['fungyImageUrl'] as String,
      fungyDescription: json['fungyDescription'] as String,
    );
  }
} 