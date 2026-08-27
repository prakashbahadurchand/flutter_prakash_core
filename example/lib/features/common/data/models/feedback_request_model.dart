class FeedbackRequestModel {
  final String feedback;
  final String? userEmail;
  final DateTime timestamp;

  const FeedbackRequestModel({
    required this.feedback,
    this.userEmail,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'feedback': feedback,
    'userEmail': userEmail,
    'timestamp': timestamp.toIso8601String(),
  };
}
