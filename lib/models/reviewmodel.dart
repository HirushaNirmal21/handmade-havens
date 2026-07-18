class Review {
  final int id;
  final String authorName;
  final String content;
  final int stars;

  Review({
    required this.id,
    required this.authorName,
    required this.content,
    required this.stars,
  });

  factory Review.fromJson(Map<String, dynamic> j) => Review(
    id: j['id'],
    authorName: j['authorName'],
    content: j['content'],
    stars: j['stars'],
  );

  Map<String, dynamic> toJson() => {
    "authorName": authorName,
    "content": content,
    "stars": stars,
  };
}
