class Drink {
  final String id;
  final String name;
  final double price;
  final String image;
  final String category;
  final String description;
  final bool isPopular;

  Drink({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.category = 'All',
    this.description = '',
    this.isPopular = false,
  });

  factory Drink.fromJson(Map<String, dynamic> json) {
    return Drink(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      category: json['category'] ?? 'All',
      description: json['description'] ?? '',
      isPopular: json['isPopular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'image': image,
        'category': category,
        'description': description,
        'isPopular': isPopular,
      };
}