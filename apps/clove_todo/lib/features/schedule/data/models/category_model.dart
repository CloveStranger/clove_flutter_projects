import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

/// Category entity for organizing schedule items
class Category {
  final String id;
  final String name;
  final String color;
  final String icon;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
    this.isDefault = false,
  });

  /// Create a new Category with validation
  factory Category.create({
    required String id,
    required String name,
    required String color,
    required String icon,
    bool isDefault = false,
  }) {
    if (id.trim().isEmpty) {
      throw ArgumentError('Category ID cannot be empty');
    }
    if (name.trim().isEmpty) {
      throw ArgumentError('Category name cannot be empty');
    }
    if (color.trim().isEmpty) {
      throw ArgumentError('Category color cannot be empty');
    }
    if (icon.trim().isEmpty) {
      throw ArgumentError('Category icon cannot be empty');
    }

    final now = DateTime.now();
    return Category(
      id: id,
      name: name.trim(),
      color: color.trim(),
      icon: icon.trim(),
      isDefault: isDefault,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Create default categories
  static List<Category> createDefaults() {
    final now = DateTime.now();
    return [
      Category(
        id: 'default_work',
        name: 'Work',
        color: '#2196F3',
        icon: 'work',
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: 'default_personal',
        name: 'Personal',
        color: '#4CAF50',
        icon: 'person',
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: 'default_health',
        name: 'Health',
        color: '#FF5722',
        icon: 'health_and_safety',
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
      Category(
        id: 'default_social',
        name: 'Social',
        color: '#9C27B0',
        icon: 'people',
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  /// Create a copy with updated fields
  Category copyWith({
    String? id,
    String? name,
    String? color,
    String? icon,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, color: $color, icon: $icon, isDefault: $isDefault)';
  }
}

/// ObjectBox model for Category entity
@Entity()
@JsonSerializable()
class CategoryModel {
  @Id()
  int id = 0;

  @Unique()
  String categoryId;
  String name;
  String color;
  String icon;
  bool isDefault;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  CategoryModel({
    required this.categoryId,
    required this.name,
    required this.color,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
    this.isDefault = false,
  });

  /// Convert from domain entity to model
  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      categoryId: category.id,
      name: category.name,
      color: category.color,
      icon: category.icon,
      isDefault: category.isDefault,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
    );
  }

  /// Convert from model to domain entity
  Category toEntity() {
    return Category(
      id: categoryId,
      name: name,
      color: color,
      icon: icon,
      isDefault: isDefault,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// JSON serialization for sync
  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  @override
  String toString() {
    return 'CategoryModel(id: $id, categoryId: $categoryId, name: $name, color: $color, icon: $icon, isDefault: $isDefault)';
  }
}
