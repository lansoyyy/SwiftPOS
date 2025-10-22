class MenuItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final bool isAvailable;
  final List<String> ingredients;
  final int preparationTime; // in minutes
  final String? spiceLevel; // mild, medium, hot, extra hot
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final int? calories;
  final double? rating;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.isAvailable = true,
    this.ingredients = const [],
    this.preparationTime = 15,
    this.spiceLevel,
    this.isVegetarian = false,
    this.isVegan = false,
    this.isGlutenFree = false,
    this.calories,
    this.rating,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      preparationTime: json['preparationTime'] ?? 15,
      spiceLevel: json['spiceLevel'],
      isVegetarian: json['isVegetarian'] ?? false,
      isVegan: json['isVegan'] ?? false,
      isGlutenFree: json['isGlutenFree'] ?? false,
      calories: json['calories'],
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'ingredients': ingredients,
      'preparationTime': preparationTime,
      'spiceLevel': spiceLevel,
      'isVegetarian': isVegetarian,
      'isVegan': isVegan,
      'isGlutenFree': isGlutenFree,
      'calories': calories,
      'rating': rating,
    };
  }

  MenuItemModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
    bool? isAvailable,
    List<String>? ingredients,
    int? preparationTime,
    String? spiceLevel,
    bool? isVegetarian,
    bool? isVegan,
    bool? isGlutenFree,
    int? calories,
    double? rating,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      ingredients: ingredients ?? this.ingredients,
      preparationTime: preparationTime ?? this.preparationTime,
      spiceLevel: spiceLevel ?? this.spiceLevel,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      calories: calories ?? this.calories,
      rating: rating ?? this.rating,
    );
  }
}

class MenuCategory {
  final String id;
  final String name;
  final String icon;
  final String color;

  MenuCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }
}
