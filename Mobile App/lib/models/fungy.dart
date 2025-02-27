class Fungy {
  final int id;
  final String name;
  final double probability;
  final bool venomous;
  String fungyImageUrl;
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
      id: json['id'] ?? 0,
      name: _decodeHtmlEntities(json['name'] ?? ''),
      probability: (json['probability'] ?? 0.0).toDouble(),
      venomous: json['venomous'] ?? false,
      fungyImageUrl: json['fungyImageUrl'] ?? '',
      fungyDescription: _decodeHtmlEntities(json['fungyDescription'] ?? ''),
    );
  }

  static String _decodeHtmlEntities(String text) {
    return text
        .replaceAll('&#x2F;', '/')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#x5C;', '\\');
  }
} 