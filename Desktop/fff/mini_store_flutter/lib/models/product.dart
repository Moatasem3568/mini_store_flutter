class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String image;
  final String description;
  final double rating;
  final int reviews;
  final int stock;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
  });

  /// تحويل من JSON إلى Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] as int,
      stock: json['stock'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// تحويل من Product إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'image': image,
      'description': description,
      'rating': rating,
      'reviews': reviews,
      'stock': stock,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// نسخ مع تعديل بعض الحقول
  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    String? image,
    String? description,
    double? rating,
    int? reviews,
    int? stock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      image: image ?? this.image,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';
}
