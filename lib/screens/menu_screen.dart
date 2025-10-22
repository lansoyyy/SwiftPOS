import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:para/models/menu_item_model.dart';
import 'package:para/utils/colors.dart';
import 'package:para/utils/constants.dart';
import 'package:para/widgets/custom_text.dart';
import 'package:para/widgets/custom_drawer.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All Menu';
  String _searchQuery = '';
  List<MenuItemModel> _menuItems = [];
  List<MenuCategory> _categories = [];
  List<MenuItemModel> _filteredItems = [];
  bool _isLoading = false;

  // Form controllers for add/edit item
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemDescriptionController =
      TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemIngredientsController =
      TextEditingController();
  final TextEditingController _itemPrepTimeController = TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();

  String _selectedItemCategory = 'burger';
  bool _itemIsAvailable = true;
  bool _itemIsVegetarian = false;
  bool _itemIsVegan = false;
  bool _itemIsGlutenFree = false;
  String? _editingItemId;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeData() {
    // Initialize categories - more POS-friendly
    _categories = [
      MenuCategory(id: 'all', name: 'All Menu', icon: '🍽️', color: '#FF6B2D'),
      MenuCategory(id: 'burger', name: 'Burger', icon: '🍔', color: '#FF5722'),
      MenuCategory(id: 'pizza', name: 'Pizza', icon: '🍕', color: '#E91E63'),
      MenuCategory(id: 'pasta', name: 'Pasta', icon: '🍝', color: '#4CAF50'),
      MenuCategory(
          id: 'beverages', name: 'Beverages', icon: '🥤', color: '#2196F3'),
      MenuCategory(
          id: 'desserts', name: 'Desserts', icon: '🍰', color: '#FFC107'),
      MenuCategory(
          id: 'specials', name: 'Specials', icon: '⭐', color: '#9C27B0'),
    ];

    // Initialize menu items with POS-appropriate data
    _menuItems = [
      // Burgers
      MenuItemModel(
        id: '1',
        name: 'Beef Burger',
        description:
            'Classic beef patty with lettuce, tomato, and special sauce',
        price: 1.50,
        category: 'burger',
        imageUrl: 'assets/images/beef_burger.jpg',
        isAvailable: true,
        ingredients: [
          'Beef patty',
          'Lettuce',
          'Tomato',
          'Bun',
          'Special sauce'
        ],
        preparationTime: 10,
        rating: 4.5,
      ),
      MenuItemModel(
        id: '2',
        name: 'Chicken Deluxe Burger',
        description: 'Crispy chicken with cheese, bacon, and ranch dressing',
        price: 1.75,
        category: 'burger',
        imageUrl: 'assets/images/chicken_burger.jpg',
        isAvailable: true,
        ingredients: [
          'Chicken patty',
          'Cheese',
          'Bacon',
          'Lettuce',
          'Ranch dressing'
        ],
        preparationTime: 12,
        rating: 4.7,
      ),
      MenuItemModel(
        id: '3',
        name: 'Cheeseburger',
        description: 'Double cheese patty with pickles and onions',
        price: 1.25,
        category: 'burger',
        imageUrl: 'assets/images/cheeseburger.jpg',
        isAvailable: true,
        ingredients: ['Beef patty', 'Cheese', 'Pickles', 'Onions', 'Bun'],
        preparationTime: 8,
        rating: 4.3,
      ),
      MenuItemModel(
        id: '4',
        name: 'Veggie Burger',
        description: 'Plant-based patty with fresh vegetables',
        price: 1.40,
        category: 'burger',
        imageUrl: 'assets/images/veggie_burger.jpg',
        isAvailable: false, // Out of stock example
        ingredients: [
          'Veggie patty',
          'Lettuce',
          'Tomato',
          'Onion',
          'Vegan mayo'
        ],
        preparationTime: 10,
        isVegetarian: true,
        isVegan: true,
        rating: 4.2,
      ),
      // Pizzas
      MenuItemModel(
        id: '5',
        name: 'Pepperoni Pizza',
        description: 'Classic pepperoni with mozzarella cheese',
        price: 2.70,
        category: 'pizza',
        imageUrl: 'assets/images/pepperoni_pizza.jpg',
        isAvailable: true,
        ingredients: ['Pizza dough', 'Tomato sauce', 'Mozzarella', 'Pepperoni'],
        preparationTime: 15,
        rating: 4.8,
      ),
      MenuItemModel(
        id: '6',
        name: 'Hawaiian Pizza',
        description: 'Ham and pineapple with mozzarella cheese',
        price: 2.60,
        category: 'pizza',
        imageUrl: 'assets/images/hawaiian_pizza.jpg',
        isAvailable: true,
        ingredients: [
          'Pizza dough',
          'Tomato sauce',
          'Mozzarella',
          'Ham',
          'Pineapple'
        ],
        preparationTime: 15,
        rating: 4.4,
      ),
      MenuItemModel(
        id: '7',
        name: 'Vegetarian Pizza',
        description: 'Fresh vegetables with mozzarella cheese',
        price: 2.50,
        category: 'pizza',
        imageUrl: 'assets/images/veggie_pizza.jpg',
        isAvailable: true,
        ingredients: [
          'Pizza dough',
          'Tomato sauce',
          'Mozzarella',
          'Bell peppers',
          'Mushrooms',
          'Olives'
        ],
        preparationTime: 15,
        isVegetarian: true,
        rating: 4.6,
      ),
      // Pasta
      MenuItemModel(
        id: '8',
        name: 'Spaghetti Bolognese',
        description: 'Classic pasta with meat sauce',
        price: 2.20,
        category: 'pasta',
        imageUrl: 'assets/images/spaghetti.jpg',
        isAvailable: true,
        ingredients: [
          'Spaghetti',
          'Ground beef',
          'Tomato sauce',
          'Onions',
          'Garlic'
        ],
        preparationTime: 18,
        rating: 4.7,
      ),
      MenuItemModel(
        id: '9',
        name: 'Chicken Alfredo',
        description: 'Creamy pasta with grilled chicken',
        price: 2.40,
        category: 'pasta',
        imageUrl: 'assets/images/alfredo.jpg',
        isAvailable: true,
        ingredients: [
          'Fettuccine',
          'Chicken',
          'Alfredo sauce',
          'Parmesan',
          'Cream'
        ],
        preparationTime: 20,
        rating: 4.5,
      ),
      // Beverages
      MenuItemModel(
        id: '10',
        name: 'Coca Cola',
        description: 'Refreshing cola drink',
        price: 0.80,
        category: 'beverages',
        imageUrl: 'assets/images/cola.jpg',
        isAvailable: true,
        ingredients: [
          'Carbonated water',
          'Sugar',
          'Caffeine',
          'Natural flavors'
        ],
        preparationTime: 2,
        rating: 4.3,
      ),
      MenuItemModel(
        id: '11',
        name: 'Orange Juice',
        description: 'Fresh squeezed orange juice',
        price: 1.20,
        category: 'beverages',
        imageUrl: 'assets/images/orange_juice.jpg',
        isAvailable: true,
        ingredients: ['Fresh oranges', 'Ice'],
        preparationTime: 3,
        isVegetarian: true,
        isVegan: true,
        rating: 4.6,
      ),
      MenuItemModel(
        id: '12',
        name: 'Coffee',
        description: 'Premium brewed coffee',
        price: 0.90,
        category: 'beverages',
        imageUrl: 'assets/images/coffee.jpg',
        isAvailable: true,
        ingredients: ['Coffee beans', 'Water'],
        preparationTime: 3,
        rating: 4.4,
      ),
      // Desserts
      MenuItemModel(
        id: '13',
        name: 'Chocolate Cake',
        description: 'Rich chocolate cake with frosting',
        price: 1.80,
        category: 'desserts',
        imageUrl: 'assets/images/chocolate_cake.jpg',
        isAvailable: true,
        ingredients: ['Flour', 'Chocolate', 'Sugar', 'Eggs', 'Butter'],
        preparationTime: 5,
        isVegetarian: true,
        rating: 4.8,
      ),
      MenuItemModel(
        id: '14',
        name: 'Ice Cream Sundae',
        description: 'Vanilla ice cream with toppings',
        price: 1.50,
        category: 'desserts',
        imageUrl: 'assets/images/ice_cream.jpg',
        isAvailable: true,
        ingredients: [
          'Vanilla ice cream',
          'Chocolate sauce',
          'Whipped cream',
          'Cherries'
        ],
        preparationTime: 3,
        isVegetarian: true,
        rating: 4.7,
      ),
      // Specials
      MenuItemModel(
        id: '15',
        name: 'Combo Meal #1',
        description: 'Burger + Fries + Drink',
        price: 3.50,
        category: 'specials',
        imageUrl: 'assets/images/combo1.jpg',
        isAvailable: true,
        ingredients: ['Beef burger', 'French fries', 'Drink'],
        preparationTime: 12,
        rating: 4.6,
      ),
      MenuItemModel(
        id: '16',
        name: 'Family Pizza Deal',
        description: 'Large pizza + 4 drinks',
        price: 8.99,
        category: 'specials',
        imageUrl: 'assets/images/family_deal.jpg',
        isAvailable: true,
        ingredients: ['Large pizza', '4 drinks'],
        preparationTime: 20,
        rating: 4.9,
      ),
    ];

    _filteredItems = _menuItems;
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filterItems();
    });
  }

  void _filterItems() {
    setState(() {
      _filteredItems = _menuItems.where((item) {
        final matchesSearch = item.name.toLowerCase().contains(_searchQuery) ||
            item.description.toLowerCase().contains(_searchQuery) ||
            item.id.toLowerCase().contains(_searchQuery);
        final matchesCategory = _selectedCategory == 'All Menu' ||
            item.category == _getCategoryId(_selectedCategory);
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  String _getCategoryId(String categoryName) {
    switch (categoryName) {
      case 'Burger':
        return 'burger';
      case 'Pizza':
        return 'pizza';
      case 'Pasta':
        return 'pasta';
      case 'Beverages':
        return 'beverages';
      case 'Desserts':
        return 'desserts';
      case 'Specials':
        return 'specials';
      default:
        return 'all';
    }
  }

  void _onCategorySelected(String categoryName) {
    setState(() {
      _selectedCategory = categoryName;
      _filterItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const CustomDrawer(currentRoute: 'menu'),
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppConstants.paddingLarge),
                  _buildCategories(),
                  const SizedBox(height: AppConstants.paddingLarge),
                  Expanded(
                    child: _buildMenuGrid(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Menu Icon
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Builder(
              builder: (context) => IconButton(
                icon: const FaIcon(FontAwesomeIcons.bars, size: 18),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          // Search Bar
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search menu items, ID, or description...',
                  hintStyle: const TextStyle(
                    fontFamily: 'Regular',
                    fontSize: AppConstants.fontMedium,
                    color: AppColors.textHint,
                  ),
                  prefixIcon: const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    size: 18,
                    color: AppColors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                    vertical: AppConstants.paddingMedium,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          // Add New Item Button
          ElevatedButton.icon(
            onPressed: _showAddItemDialog,
            icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
            label: const CustomText.bold(
              text: 'Add Item',
              fontSize: AppConstants.fontMedium,
              color: AppColors.white,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingLarge,
                vertical: AppConstants.paddingMedium,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText.bold(
          text: 'Menu Management',
          fontSize: AppConstants.fontHeading,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        Row(
          children: [
            const CustomText.regular(
              text: 'Manage your restaurant menu items and pricing',
              fontSize: AppConstants.fontMedium,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              ),
              child: CustomText.regular(
                text: '${_filteredItems.length} Items',
                fontSize: AppConstants.fontSmall,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            // Manage Categories Button
            Container(
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: IconButton(
                onPressed: _showManageCategoriesDialog,
                icon: const FaIcon(
                  FontAwesomeIcons.layerGroup,
                  size: 16,
                  color: AppColors.info,
                ),
                tooltip: 'Manage Categories',
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            // Toggle View Button
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: IconButton(
                onPressed: () {
                  // TODO: Implement view toggle
                },
                icon: const FaIcon(
                  FontAwesomeIcons.grip,
                  size: 16,
                  color: AppColors.primary,
                ),
                tooltip: 'Toggle View',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category.name;
          return GestureDetector(
            onTap: () => _onCategorySelected(category.name),
            child: Container(
              margin: const EdgeInsets.only(right: AppConstants.paddingMedium),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingLarge,
                vertical: AppConstants.paddingMedium,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.greyLight.withOpacity(0.5),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.white.withOpacity(0.2)
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusSmall),
                    ),
                    child: Text(
                      category.icon,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText.bold(
                        text: category.name,
                        fontSize: AppConstants.fontMedium,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textPrimary,
                      ),
                      CustomText.regular(
                        text: '${_getCategoryItemCount(category.id)} items',
                        fontSize: 10,
                        color: isSelected
                            ? AppColors.white.withOpacity(0.8)
                            : AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  int _getCategoryItemCount(String categoryId) {
    if (categoryId == 'all') return _menuItems.length;
    return _menuItems.where((item) => item.category == categoryId).length;
  }

  Widget _buildMenuGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.85,
        crossAxisSpacing: AppConstants.paddingMedium,
        mainAxisSpacing: AppConstants.paddingMedium,
      ),
      itemCount: _filteredItems.length,
      itemBuilder: (context, index) {
        return _buildMenuItemCard(_filteredItems[index]);
      },
    );
  }

  Widget _buildMenuItemCard(MenuItemModel item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(
          color: item.isAvailable
              ? AppColors.greyLight.withOpacity(0.5)
              : AppColors.error.withOpacity(0.3),
          width: item.isAvailable ? 1 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image/Icon Section
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.primaryLight.withOpacity(0.05),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.radiusLarge),
                  topRight: Radius.circular(AppConstants.radiusLarge),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: FaIcon(
                      _getCategoryIcon(item.category),
                      size: 48,
                      color: AppColors.primary.withOpacity(0.7),
                    ),
                  ),
                  // Availability Badge
                  if (!item.isAvailable)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusSmall),
                        ),
                        child: const CustomText.regular(
                          text: 'Out of Stock',
                          fontSize: 10,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  // Item ID Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background.withOpacity(0.9),
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                      child: CustomText.medium(
                        text: '#${item.id}',
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content Section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText.bold(
                        text: item.name,
                        fontSize: AppConstants.fontMedium,
                        color: AppColors.textPrimary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      CustomText.regular(
                        text: item.description,
                        fontSize: AppConstants.fontSmall - 2,
                        color: AppColors.textSecondary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomText.bold(
                          text: 'P${item.price.toStringAsFixed(2)}',
                          fontSize: AppConstants.fontLarge,
                          color: AppColors.primary,
                        ),
                      ),
                      // Action Buttons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _showEditItemDialog(item),
                            icon: const FaIcon(
                              FontAwesomeIcons.edit,
                              size: 14,
                              color: AppColors.info,
                            ),
                            tooltip: 'Edit Item',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 24,
                              minHeight: 24,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _toggleItemAvailability(item),
                            icon: FaIcon(
                              item.isAvailable
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              size: 14,
                              color: item.isAvailable
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                            tooltip:
                                item.isAvailable ? 'Hide Item' : 'Show Item',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 24,
                              minHeight: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'burger':
        return FontAwesomeIcons.burger;
      case 'pizza':
        return FontAwesomeIcons.pizzaSlice;
      case 'pasta':
        return FontAwesomeIcons.bowlFood;
      case 'beverages':
        return FontAwesomeIcons.wineGlass;
      case 'desserts':
        return FontAwesomeIcons.iceCream;
      case 'specials':
        return FontAwesomeIcons.star;
      default:
        return FontAwesomeIcons.utensils;
    }
  }

  void _showAddItemDialog() {
    _clearItemForm();
    _editingItemId = null;
    _showItemDialog();
  }

  void _showEditItemDialog(MenuItemModel item) {
    _populateItemForm(item);
    _editingItemId = item.id;
    _showItemDialog();
  }

  void _clearItemForm() {
    _itemNameController.clear();
    _itemDescriptionController.clear();
    _itemPriceController.clear();
    _itemIngredientsController.clear();
    _itemPrepTimeController.clear();
    _selectedItemCategory = 'burger';
    _itemIsAvailable = true;
    _itemIsVegetarian = false;
    _itemIsVegan = false;
    _itemIsGlutenFree = false;
  }

  void _populateItemForm(MenuItemModel item) {
    _itemNameController.text = item.name;
    _itemDescriptionController.text = item.description;
    _itemPriceController.text = item.price.toString();
    _itemIngredientsController.text = item.ingredients.join(', ');
    _itemPrepTimeController.text = item.preparationTime.toString();
    _selectedItemCategory = item.category;
    _itemIsAvailable = item.isAvailable;
    _itemIsVegetarian = item.isVegetarian;
    _itemIsVegan = item.isVegan;
    _itemIsGlutenFree = item.isGlutenFree;
  }

  void _showItemDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        child: Container(
          width: 600,
          constraints: const BoxConstraints(maxHeight: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppConstants.radiusLarge),
                    topRight: Radius.circular(AppConstants.radiusLarge),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusMedium),
                      ),
                      child: FaIcon(
                        _editingItemId == null
                            ? FontAwesomeIcons.plus
                            : FontAwesomeIcons.edit,
                        size: 24,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingMedium),
                    Expanded(
                      child: CustomText.bold(
                        text: _editingItemId == null
                            ? 'Add New Menu Item'
                            : 'Edit Menu Item',
                        fontSize: AppConstants.fontHeading,
                        color: AppColors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const FaIcon(
                        FontAwesomeIcons.xmark,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Form
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Information
                      _buildFormSection('Basic Information', [
                        _buildTextField('Item Name', _itemNameController,
                            'Enter item name'),
                        _buildTextField(
                            'Description',
                            _itemDescriptionController,
                            'Enter item description'),
                        _buildTextField(
                            'Price (₱)', _itemPriceController, '0.00',
                            isNumber: true),
                      ]),

                      const SizedBox(height: AppConstants.paddingLarge),

                      // Category & Details
                      _buildFormSection('Category & Details', [
                        _buildCategoryDropdown(),
                        _buildTextField('Preparation Time (minutes)',
                            _itemPrepTimeController, '15',
                            isNumber: true),
                        _buildTextField('Ingredients (comma separated)',
                            _itemIngredientsController, 'Enter ingredients'),
                      ]),

                      const SizedBox(height: AppConstants.paddingLarge),

                      // Dietary Options
                      _buildFormSection('Dietary Options', [
                        _buildCheckbox(
                            'Available',
                            _itemIsAvailable,
                            (value) =>
                                setState(() => _itemIsAvailable = value!)),
                        _buildCheckbox(
                            'Vegetarian',
                            _itemIsVegetarian,
                            (value) =>
                                setState(() => _itemIsVegetarian = value!)),
                        _buildCheckbox('Vegan', _itemIsVegan,
                            (value) => setState(() => _itemIsVegan = value!)),
                        _buildCheckbox(
                            'Gluten-Free',
                            _itemIsGlutenFree,
                            (value) =>
                                setState(() => _itemIsGlutenFree = value!)),
                      ]),
                    ],
                  ),
                ),
              ),
              // Actions
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppConstants.radiusLarge),
                    bottomRight: Radius.circular(AppConstants.radiusLarge),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.paddingMedium),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusMedium),
                          ),
                          side: BorderSide(color: AppColors.greyLight),
                        ),
                        child: const CustomText.medium(
                          text: 'Cancel',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingMedium),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveMenuItem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.paddingMedium),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusMedium),
                          ),
                        ),
                        child: CustomText.medium(
                          text: _editingItemId == null
                              ? 'Add Item'
                              : 'Save Changes',
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.bold(
          text: title,
          fontSize: AppConstants.fontLarge,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        ...children,
      ],
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hintText,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText.medium(
            text: label,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                borderSide: BorderSide(color: AppColors.greyLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                borderSide: BorderSide(color: AppColors.greyLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              contentPadding: const EdgeInsets.all(AppConstants.paddingMedium),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText.medium(
            text: 'Category',
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyLight),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedItemCategory,
                items:
                    _categories.where((cat) => cat.id != 'all').map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Row(
                      children: [
                        Text(category.icon,
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: AppConstants.paddingSmall),
                        CustomText.medium(text: category.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedItemCategory = value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
          CustomText.medium(text: label),
        ],
      ),
    );
  }

  void _saveMenuItem() {
    if (_itemNameController.text.trim().isEmpty ||
        _itemPriceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final newItem = MenuItemModel(
      id: _editingItemId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _itemNameController.text.trim(),
      description: _itemDescriptionController.text.trim(),
      price: double.tryParse(_itemPriceController.text) ?? 0.0,
      category: _selectedItemCategory,
      imageUrl: 'assets/images/placeholder.jpg',
      isAvailable: _itemIsAvailable,
      ingredients: _itemIngredientsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      preparationTime: int.tryParse(_itemPrepTimeController.text) ?? 15,
      isVegetarian: _itemIsVegetarian,
      isVegan: _itemIsVegan,
      isGlutenFree: _itemIsGlutenFree,
    );

    setState(() {
      if (_editingItemId != null) {
        final index =
            _menuItems.indexWhere((item) => item.id == _editingItemId);
        if (index != -1) {
          _menuItems[index] = newItem;
        }
      } else {
        _menuItems.add(newItem);
      }
      _filterItems();
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_editingItemId == null
            ? 'Item added successfully!'
            : 'Item updated successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showManageCategoriesDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.layerGroup,
                      size: 24,
                      color: AppColors.info,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: CustomText.bold(
                      text: 'Manage Categories',
                      fontSize: AppConstants.fontLarge,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const FaIcon(
                      FontAwesomeIcons.xmark,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingLarge),

              // Add New Category
              CustomText.bold(
                text: 'Add New Category',
                fontSize: AppConstants.fontMedium,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _categoryNameController,
                      decoration: InputDecoration(
                        hintText: 'Category name',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMedium),
                          borderSide: BorderSide(color: AppColors.greyLight),
                        ),
                        contentPadding:
                            const EdgeInsets.all(AppConstants.paddingMedium),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  ElevatedButton.icon(
                    onPressed: _addNewCategory,
                    icon: const FaIcon(FontAwesomeIcons.plus, size: 14),
                    label: const CustomText.medium(text: 'Add'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.info,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingLarge,
                        vertical: AppConstants.paddingMedium,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingLarge),

              // Existing Categories
              CustomText.bold(
                text: 'Existing Categories',
                fontSize: AppConstants.fontMedium,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _categories.where((cat) => cat.id != 'all').length,
                  itemBuilder: (context, index) {
                    final category = _categories
                        .where((cat) => cat.id != 'all')
                        .elementAt(index);
                    return Container(
                      margin: const EdgeInsets.only(
                          bottom: AppConstants.paddingSmall),
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusMedium),
                        border: Border.all(
                            color: AppColors.greyLight.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          Text(category.icon,
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: AppConstants.paddingMedium),
                          Expanded(
                            child: CustomText.medium(
                              text: category.name,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _deleteCategory(category.id),
                            icon: const FaIcon(
                              FontAwesomeIcons.trash,
                              size: 14,
                              color: AppColors.error,
                            ),
                            tooltip: 'Delete Category',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addNewCategory() {
    final categoryName = _categoryNameController.text.trim();
    if (categoryName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a category name'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final newCategory = MenuCategory(
      id: categoryName.toLowerCase().replaceAll(' ', '_'),
      name: categoryName,
      icon: '🍽️',
      color: '#FF6B2D',
    );

    setState(() {
      _categories.add(newCategory);
    });

    _categoryNameController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Category "$categoryName" added successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _deleteCategory(String categoryId) {
    // Check if category has items
    final hasItems = _menuItems.any((item) => item.category == categoryId);
    if (hasItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot delete category with existing items'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _categories.removeWhere((cat) => cat.id == categoryId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Category deleted successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _toggleItemAvailability(MenuItemModel item) {
    setState(() {
      final index = _menuItems.indexWhere((menuItem) => menuItem.id == item.id);
      if (index != -1) {
        _menuItems[index] =
            _menuItems[index].copyWith(isAvailable: !item.isAvailable);
        _filterItems();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item.name} is now ${item.isAvailable ? 'hidden' : 'available'}',
        ),
        backgroundColor:
            item.isAvailable ? AppColors.warning : AppColors.success,
      ),
    );
  }
}
