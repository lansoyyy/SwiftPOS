import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:para/utils/colors.dart';
import 'package:para/utils/constants.dart';
import 'package:para/widgets/custom_button.dart';
import 'package:para/widgets/custom_text.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedCategory = 'All Menu';
  String _selectedPaymentMethod = 'Cash';
  String _selectedTable = 'Table 20';
  String _dineOption = 'Dine In';
  bool _showOrders = true;

  final List<Map<String, dynamic>> _orders = [
    {
      'id': '#010',
      'cashier': 'Broicad',
      'items': 4,
      'table': 'Table 4C',
      'order': '3x Burgers 3x Orange juice',
      'status': 'Being Cooked',
      'statusColor': AppColors.warning,
    },
    {
      'id': '#016',
      'cashier': 'Broicad',
      'items': 4,
      'table': 'Table 4C',
      'order': '3x Burgers 3x Orange juice',
      'status': 'Being Cooked',
      'statusColor': AppColors.warning,
    },
    {
      'id': '#018',
      'cashier': 'Broicad',
      'items': 4,
      'table': 'Table 4C',
      'order': '3x Burgers 3x Orange juice',
      'status': 'Being Cooked',
      'statusColor': AppColors.warning,
    },
    {
      'id': '#018',
      'cashier': 'Broicad',
      'items': 4,
      'table': 'Table 4C',
      'order': '3x Burgers 3x Orange juice',
      'status': 'Delivered',
      'statusColor': AppColors.success,
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All Menu', 'icon': FontAwesomeIcons.utensils, 'count': 40},
    {'name': 'Burger', 'icon': FontAwesomeIcons.burger, 'count': 8},
    {'name': 'Pizza', 'icon': FontAwesomeIcons.pizzaSlice, 'count': 4},
    {'name': 'Spaghetti', 'icon': FontAwesomeIcons.bowlFood, 'count': 14},
    {'name': 'French Fries', 'icon': FontAwesomeIcons.bowlRice, 'count': 6},
    {'name': 'Beverage', 'icon': FontAwesomeIcons.wineGlass, 'count': 10},
  ];

  final List<Map<String, dynamic>> _menuItems = [
    {
      'name': 'Beef Burger',
      'price': 1.50,
      'category': 'Burger',
      'image': 'placeholder',
    },
    {
      'name': 'Chicken Deluxe Burger',
      'price': 1.50,
      'category': 'Burger',
      'image': 'placeholder',
    },
    {
      'name': 'Cheeseburger',
      'price': 1.50,
      'category': 'Burger',
      'image': 'placeholder',
    },
    {
      'name': 'Classic Burger',
      'price': 1.50,
      'category': 'Burger',
      'image': 'placeholder',
    },
    {
      'name': 'Double Beef Burger',
      'price': 1.50,
      'category': 'Burger',
      'image': 'placeholder',
    },
    {
      'name': 'Chicken Supreme Pizza',
      'price': 2.60,
      'category': 'Pizza',
      'image': 'placeholder',
    },
    {
      'name': 'Pepperoni Pizza',
      'price': 2.70,
      'category': 'Pizza',
      'image': 'placeholder',
    },
    {
      'name': 'Hawaiian Pizza',
      'price': 2.60,
      'category': 'Pizza',
      'image': 'placeholder',
    },
  ];

  final List<Map<String, dynamic>> _currentOrderItems = [
    {'name': 'Beef Burger', 'price': 2.50, 'quantity': 1},
    {'name': 'Chicken Deluxe Burger', 'price': 4.25, 'quantity': 2},
    {'name': 'Cheeseburger', 'price': 2.24, 'quantity': 1},
  ];

  double get _subtotal {
    return _currentOrderItems.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  double get _tax => _subtotal * 0.11;
  double get _total => _subtotal + _tax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Left Panel - Orders and Menu
          Expanded(
            flex: 7,
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildOrderList(),
                        const SizedBox(height: AppConstants.paddingSmall),
                        _buildMenuSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Right Panel - Current Order
          Container(
            width: 400,
            color: AppColors.white,
            child: _buildOrderPanel(),
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
          bottom:
              BorderSide(color: AppColors.border.withOpacity(0.3), width: 1),
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
            child: IconButton(
              icon: const FaIcon(FontAwesomeIcons.bars, size: 18),
              onPressed: () {},
              color: AppColors.primary,
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
                decoration: InputDecoration(
                  hintText: 'Search menu items, orders...',
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
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingSmall,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusSmall),
                    ),
                    child: const Icon(
                      FontAwesomeIcons.filter,
                      size: 14,
                      color: AppColors.white,
                    ),
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
          // Action Buttons
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                label: const CustomText.bold(
                  text: 'Close Order',
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
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText.bold(
              text: 'Active Orders',
              fontSize: AppConstants.fontHeading,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingSmall,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
              ),
              child: CustomText.regular(
                text: '${_orders.length} Orders',
                fontSize: AppConstants.fontSmall,
                color: AppColors.white,
              ),
            ),
            const Spacer(),
            // Filter Dropdown
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.clockRotateLeft,
                    size: 14,
                    color: AppColors.grey,
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  const CustomText.regular(
                    text: 'Recent',
                    fontSize: AppConstants.fontSmall,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  const FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 12,
                    color: AppColors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            // Hide/Show Toggle
            GestureDetector(
              onTap: () {
                setState(() {
                  _showOrders = !_showOrders;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: _showOrders
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.background,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(
                    color: _showOrders
                        ? AppColors.primary
                        : AppColors.greyLight.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FaIcon(
                      _showOrders
                          ? FontAwesomeIcons.eyeSlash
                          : FontAwesomeIcons.eye,
                      size: 14,
                      color: _showOrders ? AppColors.primary : AppColors.grey,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    CustomText.medium(
                      text: _showOrders ? 'Hide' : 'Show',
                      fontSize: AppConstants.fontSmall,
                      color: _showOrders
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingLarge),
        // Orders Section with Animation
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _showOrders ? 200 : 0,
          curve: Curves.easeInOut,
          child: _showOrders
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    return _buildOrderCard(_orders[index]);
                  },
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: order['statusColor'].withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.radiusLarge),
                topRight: Radius.circular(AppConstants.radiusLarge),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: order['statusColor'].withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                      child: FaIcon(
                        order['status'] == 'Delivered'
                            ? FontAwesomeIcons.check
                            : FontAwesomeIcons.clock,
                        size: 12,
                        color: order['statusColor'],
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    CustomText.bold(
                      text: order['id'],
                      fontSize: AppConstants.fontMedium,
                      color: AppColors.textPrimary,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingSmall,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                      child: CustomText.regular(
                        text: order['table'],
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const FaIcon(
                        FontAwesomeIcons.user,
                        size: 12,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    CustomText.medium(
                      text: order['cashier'],
                      fontSize: AppConstants.fontSmall,
                      color: AppColors.textPrimary,
                    ),
                    const Spacer(),
                    CustomText.regular(
                      text: '${order['items']} items',
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText.regular(
                    text: 'Order Details',
                    fontSize: AppConstants.fontSmall,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 4),
                  CustomText.medium(
                    text: order['order'],
                    fontSize: AppConstants.fontSmall,
                    color: AppColors.textPrimary,
                    maxLines: 2,
                  ),
                  const Spacer(),
                  // Status
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingSmall,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: order['statusColor'].withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          order['status'] == 'Delivered'
                              ? FontAwesomeIcons.checkCircle
                              : FontAwesomeIcons.fire,
                          size: 12,
                          color: order['statusColor'],
                        ),
                        const SizedBox(width: 6),
                        CustomText.medium(
                          text: order['status'],
                          fontSize: AppConstants.fontSmall,
                          color: order['statusColor'],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText.bold(
                text: 'Menu',
                fontSize: AppConstants.fontExtraLarge,
                color: AppColors.textPrimary,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              CustomText.regular(
                text: '(40 Items)',
                fontSize: AppConstants.fontSmall,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          // Category Tabs
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryTab(_categories[index]);
              },
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          // Menu Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.85,
                crossAxisSpacing: AppConstants.paddingMedium,
                mainAxisSpacing: AppConstants.paddingMedium,
              ),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                return _buildMenuItem(_menuItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(Map<String, dynamic> category) {
    final isSelected = _selectedCategory == category['name'];
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category['name'];
        });
      },
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
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.white.withOpacity(0.2)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: FaIcon(
                category['icon'],
                size: 16,
                color: isSelected ? AppColors.white : AppColors.primary,
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.bold(
                  text: category['name'],
                  fontSize: AppConstants.fontMedium,
                  color: isSelected ? AppColors.white : AppColors.textPrimary,
                ),
                CustomText.regular(
                  text: '${category['count']} items',
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
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
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
          // Image
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
                      _getCategoryIcon(item['category']),
                      size: 48,
                      color: AppColors.primary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText.bold(
                    text: item['name'],
                    fontSize: AppConstants.fontMedium,
                    color: AppColors.textPrimary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingSmall,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusSmall),
                        ),
                        child: CustomText.medium(
                          text: item['category'],
                          fontSize: 10,
                          color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      CustomText.bold(
                        text: '\$${item['price'].toStringAsFixed(2)}',
                        fontSize: AppConstants.fontLarge,
                        color: AppColors.primary,
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
      case 'Burger':
        return FontAwesomeIcons.burger;
      case 'Pizza':
        return FontAwesomeIcons.pizzaSlice;
      case 'Spaghetti':
        return FontAwesomeIcons.bowlFood;
      case 'French Fries':
        return FontAwesomeIcons.bowlRice;
      case 'Beverage':
        return FontAwesomeIcons.wineGlass;
      default:
        return FontAwesomeIcons.utensils;
    }
  }

  Widget _buildOrderPanel() {
    return Column(
      children: [
        // Header
        Container(
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
                  color: AppColors.border.withOpacity(0.3), width: 1),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.primaryDark,
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.receipt,
                      size: 16,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText.bold(
                          text: 'Current Order',
                          fontSize: AppConstants.fontLarge,
                          color: AppColors.textPrimary,
                        ),
                        CustomText.regular(
                          text: 'Order #0022',
                          fontSize: AppConstants.fontSmall,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingMedium,
                      vertical: AppConstants.paddingSmall,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMedium),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.user,
                          size: 12,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 4),
                        const CustomText.medium(
                          text: 'Avita Desi',
                          fontSize: AppConstants.fontSmall,
                          color: AppColors.success,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                        _selectedTable, ['Table 20', 'Table 21', 'Table 22']),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Expanded(
                    child: _buildDropdown(
                        _dineOption, ['Dine In', 'Take Out', 'Delivery']),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Order Items
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            itemCount: _currentOrderItems.length,
            itemBuilder: (context, index) {
              return _buildOrderItem(_currentOrderItems[index]);
            },
          ),
        ),
        // Summary and Payment
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.border, width: 1),
            ),
          ),
          child: Column(
            children: [
              _buildSummaryRow('Sub Total', _subtotal),
              const SizedBox(height: AppConstants.paddingSmall),
              _buildSummaryRow('Tax (11%)', _tax),
              const SizedBox(height: AppConstants.paddingSmall),
              const Divider(),
              _buildSummaryRow('Total', _total, isBold: true),
              const SizedBox(height: AppConstants.paddingLarge),
              const CustomText.bold(
                text: 'Payment Method',
                fontSize: AppConstants.fontMedium,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Row(
                children: [
                  Expanded(
                    child: _buildPaymentMethod(
                      'Credit Card',
                      FontAwesomeIcons.creditCard,
                      Colors.red,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Expanded(
                    child: _buildPaymentMethod(
                      'Cash',
                      FontAwesomeIcons.moneyBill,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Expanded(
                    child: _buildPaymentMethod(
                      'GCash',
                      FontAwesomeIcons.qrcode,
                      AppColors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingLarge),
              CustomButton(
                text: 'Place Order',
                onPressed: _showOrderConfirmationDialog,
                backgroundColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String value, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText.medium(
            text: value,
            fontSize: AppConstants.fontMedium,
            color: AppColors.textPrimary,
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: const FaIcon(
              FontAwesomeIcons.chevronDown,
              size: 10,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: AppColors.greyLight.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.primaryLight.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            child: Center(
              child: FaIcon(
                _getCategoryIcon('Burger'),
                size: 24,
                color: AppColors.primary.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.bold(
                  text: item['name'],
                  fontSize: AppConstants.fontMedium,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: 4),
                CustomText.bold(
                  text: '\$${item['price'].toStringAsFixed(2)}',
                  fontSize: AppConstants.fontSmall,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),

          const SizedBox(width: AppConstants.paddingSmall),
          // Quantity Controls
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const FaIcon(
                    FontAwesomeIcons.minus,
                    size: 12,
                    color: AppColors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                    vertical: 8,
                  ),
                  child: CustomText.bold(
                    text: '${item['quantity']}',
                    fontSize: AppConstants.fontMedium,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(AppConstants.radiusMedium),
                      bottomRight: Radius.circular(AppConstants.radiusMedium),
                    ),
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.plus,
                    size: 12,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          fontSize: AppConstants.fontMedium,
          color: AppColors.textSecondary,
          fontFamily: isBold ? 'Bold' : 'Regular',
        ),
        CustomText(
          text: '\$${amount.toStringAsFixed(2)}',
          fontSize: AppConstants.fontMedium,
          color: AppColors.textPrimary,
          fontFamily: isBold ? 'Bold' : 'Regular',
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(String label, IconData icon, Color color) {
    final isSelected = _selectedPaymentMethod == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
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
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: FaIcon(
                icon,
                size: 24,
                color: isSelected ? AppColors.primary : color,
              ),
            ),
            const SizedBox(height: 8),
            CustomText.bold(
              text: label,
              fontSize: AppConstants.fontSmall,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          child: Container(
            width: 500,
            constraints: const BoxConstraints(maxHeight: 600),
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
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMedium),
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.receipt,
                          size: 32,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      const CustomText.bold(
                        text: 'Order Confirmation',
                        fontSize: AppConstants.fontHeading,
                        color: AppColors.white,
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      const CustomText.regular(
                        text: 'Please review your order details',
                        fontSize: AppConstants.fontMedium,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Info
                        _buildOrderInfoRow('Order Number', '#0022'),
                        _buildOrderInfoRow('Table', _selectedTable),
                        _buildOrderInfoRow('Dine Option', _dineOption),
                        _buildOrderInfoRow(
                            'Payment Method', _selectedPaymentMethod),
                        const SizedBox(height: AppConstants.paddingLarge),

                        // Order Items
                        const CustomText.bold(
                          text: 'Order Items',
                          fontSize: AppConstants.fontLarge,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(height: AppConstants.paddingMedium),
                        ..._currentOrderItems
                            .map((item) => _buildOrderSummaryItem(item)),

                        const SizedBox(height: AppConstants.paddingLarge),

                        // Summary
                        Container(
                          padding:
                              const EdgeInsets.all(AppConstants.paddingMedium),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusMedium),
                          ),
                          child: Column(
                            children: [
                              _buildSummaryRow('Sub Total', _subtotal),
                              const SizedBox(height: AppConstants.paddingSmall),
                              _buildSummaryRow('Tax (11%)', _tax),
                              const SizedBox(height: AppConstants.paddingSmall),
                              const Divider(),
                              _buildSummaryRow('Total', _total, isBold: true),
                            ],
                          ),
                        ),
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
                        child: CustomButton(
                          text: 'Cancel',
                          onPressed: () => Navigator.of(context).pop(),
                          isOutlined: true,
                          backgroundColor: AppColors.greyLight,
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: CustomButton(
                          text: 'Confirm Order',
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showOrderSuccessDialog();
                          },
                          backgroundColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Row(
        children: [
          CustomText.regular(
            text: '$label:',
            fontSize: AppConstants.fontMedium,
            color: AppColors.textSecondary,
          ),
          const Spacer(),
          CustomText.bold(
            text: value,
            fontSize: AppConstants.fontMedium,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.primaryLight.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.burger,
                size: 20,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.bold(
                  text: item['name'],
                  fontSize: AppConstants.fontMedium,
                  color: AppColors.textPrimary,
                ),
                CustomText.regular(
                  text: '\$${item['price'].toStringAsFixed(2)} each',
                  fontSize: AppConstants.fontSmall,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: CustomText.bold(
              text: 'x${item['quantity']}',
              fontSize: AppConstants.fontMedium,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          CustomText.bold(
            text: '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
            fontSize: AppConstants.fontLarge,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  void _showOrderSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          child: Container(
            padding: const EdgeInsets.all(AppConstants.paddingExtraLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.check,
                    size: 48,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                const CustomText.bold(
                  text: 'Order Placed Successfully!',
                  fontSize: AppConstants.fontHeading,
                  color: AppColors.textPrimary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                const CustomText.regular(
                  text: 'Your order has been confirmed and is being prepared.',
                  fontSize: AppConstants.fontMedium,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.paddingLarge),
                CustomButton(
                  text: 'OK',
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Clear the current order
                    setState(() {
                      _currentOrderItems.clear();
                    });
                  },
                  backgroundColor: AppColors.success,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
