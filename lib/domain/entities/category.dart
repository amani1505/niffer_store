class Category {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final String? parentId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    this.parentId,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });
}