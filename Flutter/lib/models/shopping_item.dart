class ShoppingItem {
  final String sku;
  final String id;
  final String brand;
  final String category;
  final String description;
  final int discountPercentage;
  final List<String> images;
  final int price;
  final int stock;
  final double rating;
  final String thumbnail;
  final String title;
  final String video;

  ShoppingItem({
    required this.sku,
    required this.id,
    required this.brand,
    required this.category,
    required this.description,
    required this.discountPercentage,
    required this.images,
    required this.price,
    required this.stock,
    required this.rating,
    required this.thumbnail,
    required this.title,
    required this.video,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      sku: json['sku'] as String,
      id: json['_id'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
      description: (json['description'] as String) ?? '',
      discountPercentage: (json['discountPercentage'] as num).toInt(),
      images: List<String>.from(json['images'] ?? []),
      price: (json['price'] as num).toInt(),
      stock: (json['stock'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      thumbnail: json['thumbnail'] as String,
      title: json['title'] as String,
      video: json['video'] as String,
    );
  }
}
