class SampleItemModel {
  final int id;
  final String title;
  final String description;
  final String category;

  const SampleItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
  });

  factory SampleItemModel.fromJson(Map<String, dynamic> json) {
    return SampleItemModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String? ?? 'General',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
    };
  }
}
