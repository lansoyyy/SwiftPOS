import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:para/utils/colors.dart';
import 'package:para/utils/constants.dart';
import 'package:para/widgets/custom_drawer.dart';
import 'package:para/widgets/custom_text.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  int _currentPage = 1;
  final int _totalPages = 10;
  String _selectedFilter = 'All Table';

  final List<Map<String, dynamic>> _tables = [
    {'number': 1, 'status': 'Available', 'guest': 'Guest'},
    {'number': 2, 'status': 'Available', 'guest': 'Guest'},
    {'number': 3, 'status': 'Used', 'guest': 'Guest'},
    {'number': 4, 'status': 'Used', 'guest': 'Guest'},
    {'number': 5, 'status': 'Used', 'guest': 'Guest'},
    {'number': 6, 'status': 'Available', 'guest': 'Guest'},
    {'number': 7, 'status': 'Used', 'guest': 'Guest'},
    {'number': 8, 'status': 'Used', 'guest': 'Guest'},
    {'number': 9, 'status': 'Used', 'guest': 'Guest'},
    {'number': 10, 'status': 'Used', 'guest': 'Guest'},
    {'number': 11, 'status': 'Used', 'guest': 'Guest'},
    {'number': 12, 'status': 'Used', 'guest': 'Guest'},
    {'number': 13, 'status': 'Used', 'guest': 'Guest'},
    {'number': 14, 'status': 'Available', 'guest': 'Guest'},
    {'number': 15, 'status': 'Used', 'guest': 'Guest'},
    {'number': 16, 'status': 'Available', 'guest': 'Guest'},
    {'number': 17, 'status': 'Available', 'guest': 'Guest'},
    {'number': 18, 'status': 'Available', 'guest': 'Guest'},
    {'number': 19, 'status': 'Used', 'guest': 'Guest'},
    {'number': 20, 'status': 'Used', 'guest': 'Guest'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const CustomDrawer(),
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
                  Expanded(
                    child: _buildTableGrid(),
                  ),
                  const SizedBox(height: AppConstants.paddingLarge),
                  _buildPagination(),
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
                decoration: InputDecoration(
                  hintText: 'Search',
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
          // Filter Dropdown
          Container(
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
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText.medium(
                  text: _selectedFilter,
                  fontSize: AppConstants.fontMedium,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 10,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          // Close Order Button
          ElevatedButton(
            onPressed: () {},
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
            child: const CustomText.bold(
              text: 'Close Order',
              fontSize: AppConstants.fontMedium,
              color: AppColors.white,
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
          text: 'Table',
          fontSize: AppConstants.fontHeading,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        const CustomText.regular(
          text:
              'Overview of Table Availability and Status for Efficient Order Management',
          fontSize: AppConstants.fontMedium,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildTableGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.45,
        crossAxisSpacing: AppConstants.paddingMedium,
        mainAxisSpacing: AppConstants.paddingMedium,
      ),
      itemCount: _tables.length,
      itemBuilder: (context, index) {
        return _buildTableCard(_tables[index]);
      },
    );
  }

  Widget _buildTableCard(Map<String, dynamic> table) {
    final isAvailable = table['status'] == 'Available';
    return GestureDetector(
      onTap: () {
        setState(() {
          table['status'] = isAvailable ? 'Used' : 'Available';
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: isAvailable
                ? AppColors.primary.withOpacity(0.3)
                : AppColors.greyLight.withOpacity(0.5),
            width: isAvailable ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isAvailable
                  ? AppColors.primary.withOpacity(0.15)
                  : Colors.black.withOpacity(0.08),
              blurRadius: isAvailable ? 15 : 10,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: isAvailable
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.white,
                    AppColors.primary.withOpacity(0.02),
                  ],
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Table Header with Icon
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.paddingSmall,
                horizontal: AppConstants.paddingMedium,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isAvailable
                      ? [
                          AppColors.primary.withOpacity(0.1),
                          AppColors.primary.withOpacity(0.02),
                        ]
                      : [
                          AppColors.greyLight.withOpacity(0.3),
                          AppColors.greyLight.withOpacity(0.1),
                        ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.radiusMedium),
                  topRight: Radius.circular(AppConstants.radiusMedium),
                ),
              ),
              child: Column(
                children: [
                  // Table Icon with Animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? AppColors.primary.withOpacity(0.15)
                          : AppColors.greyLight.withOpacity(0.5),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: isAvailable
                              ? AppColors.primary.withOpacity(0.2)
                              : Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.chair,
                      size: 18,
                      color: isAvailable ? AppColors.primary : AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Table Number
                  CustomText.bold(
                    text: 'Table ${table['number']}',
                    fontSize: AppConstants.fontMedium,
                    color:
                        isAvailable ? AppColors.primary : AppColors.textPrimary,
                  ),
                ],
              ),
            ),

            // Status Badge with Animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              margin: const EdgeInsets.all(AppConstants.paddingMedium),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: AppConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: isAvailable ? AppColors.primary : AppColors.greyLight,
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                boxShadow: [
                  BoxShadow(
                    color: isAvailable
                        ? AppColors.primary.withOpacity(0.3)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: FaIcon(
                      isAvailable
                          ? FontAwesomeIcons.checkCircle
                          : FontAwesomeIcons.clock,
                      key: ValueKey(isAvailable),
                      size: 14,
                      color: isAvailable
                          ? AppColors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomText.bold(
                    text: table['status'],
                    fontSize: AppConstants.fontSmall,
                    color:
                        isAvailable ? AppColors.white : AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText.regular(
          text: 'Page $_currentPage of $_totalPages',
          fontSize: AppConstants.fontMedium,
          color: AppColors.textSecondary,
        ),
        Row(
          children: [
            _buildPaginationButton(
              icon: FontAwesomeIcons.chevronLeft,
              onPressed: _currentPage > 1
                  ? () {
                      setState(() {
                        _currentPage--;
                      });
                    }
                  : null,
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            ..._buildPageNumbers(),
            const SizedBox(width: AppConstants.paddingSmall),
            _buildPaginationButton(
              icon: FontAwesomeIcons.chevronRight,
              onPressed: _currentPage < _totalPages
                  ? () {
                      setState(() {
                        _currentPage++;
                      });
                    }
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pages = [];

    // Show first page
    pages.add(_buildPageNumber(1));

    if (_currentPage > 3) {
      pages.add(const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: CustomText.regular(
          text: '...',
          fontSize: AppConstants.fontMedium,
          color: AppColors.textSecondary,
        ),
      ));
    }

    // Show current page and neighbors
    for (int i = _currentPage - 1; i <= _currentPage + 1; i++) {
      if (i > 1 && i < _totalPages) {
        pages.add(_buildPageNumber(i));
      }
    }

    if (_currentPage < _totalPages - 2) {
      pages.add(const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: CustomText.regular(
          text: '...',
          fontSize: AppConstants.fontMedium,
          color: AppColors.textSecondary,
        ),
      ));
    }

    // Show last page
    if (_totalPages > 1) {
      pages.add(_buildPageNumber(_totalPages));
    }

    return pages;
  }

  Widget _buildPageNumber(int pageNumber) {
    final isSelected = pageNumber == _currentPage;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentPage = pageNumber;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.greyLight.withOpacity(0.5),
          ),
        ),
        child: CustomText.medium(
          text: pageNumber.toString(),
          fontSize: AppConstants.fontSmall,
          color: isSelected ? AppColors.white : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildPaginationButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
        border: Border.all(color: AppColors.greyLight.withOpacity(0.5)),
      ),
      child: IconButton(
        icon: FaIcon(
          icon,
          size: 14,
          color: onPressed != null ? AppColors.textPrimary : AppColors.grey,
        ),
        onPressed: onPressed,
      ),
    );
  }

  void _showTableOptions(BuildContext context, Map<String, dynamic> table) {
    final isAvailable = table['status'] == 'Available';
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.radiusLarge),
          topRight: Radius.circular(AppConstants.radiusLarge),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.greyLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            // Table Info
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.greyLight.withOpacity(0.5),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMedium),
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.chair,
                    size: 20,
                    color: isAvailable ? AppColors.primary : AppColors.grey,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText.bold(
                        text: 'Table ${table['number']}',
                        fontSize: AppConstants.fontLarge,
                        color: AppColors.textPrimary,
                      ),
                      CustomText.regular(
                        text: 'Status: ${table['status']}',
                        fontSize: AppConstants.fontMedium,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: _buildOptionButton(
                    icon: isAvailable
                        ? FontAwesomeIcons.userMinus
                        : FontAwesomeIcons.userPlus,
                    label: isAvailable ? 'Mark as Used' : 'Mark as Available',
                    color: isAvailable ? AppColors.warning : AppColors.success,
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        table['status'] = isAvailable ? 'Used' : 'Available';
                      });
                    },
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: _buildOptionButton(
                    icon: FontAwesomeIcons.pencil,
                    label: 'Edit Details',
                    color: AppColors.primary,
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Implement edit functionality
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            SizedBox(
              width: double.infinity,
              child: _buildOptionButton(
                icon: FontAwesomeIcons.circleInfo,
                label: 'View Details',
                color: AppColors.info,
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement view details functionality
                },
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingMedium,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon, size: 16),
          const SizedBox(width: AppConstants.paddingSmall),
          CustomText.medium(
            text: label,
            fontSize: AppConstants.fontSmall,
          ),
        ],
      ),
    );
  }
}
