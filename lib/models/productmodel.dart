class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  int stockQuantity;
  final String? imageUrl;
  final String? category;
  int likeCount;
  bool isLiked;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    this.imageUrl,
    this.category,
    this.likeCount = 0,
    this.isLiked = false,
  });

  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    int? stockQuantity,
    String? imageUrl,
    String? category,
    int? likeCount,
    bool? isLiked,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] is String
          ? (int.tryParse(json['id']) ?? 0)
          : (json['id'] ?? 0),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: json['stockQuantity'] is String
          ? (int.tryParse(json['stockQuantity']) ?? 0)
          : (json['stockQuantity'] ?? 0),
      imageUrl: json['imageUrl'],
      category: json['category'],
      likeCount: json['likeCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != 0) 'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stockQuantity': stockQuantity,
      'imageUrl': imageUrl,
      'category': category,
      'likeCount': likeCount,
      'isLiked': isLiked,
    };
  }
}
