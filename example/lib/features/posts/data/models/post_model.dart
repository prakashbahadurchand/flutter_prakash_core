/// Data-transfer object mirroring the REST `Post` JSON shape.
///
/// Clean Architecture **data** layer: owned by the data layer so connectivity
/// to the wire format never leaks into the domain entity.
class PostModel {
  final int id;
  final int userId;
  final String title;
  final String body;

  const PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }
}