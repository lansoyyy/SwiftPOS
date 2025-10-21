import 'package:flutter/material.dart';
import 'package:para/utils/colors.dart';
import 'package:para/utils/constants.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? fontFamily;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.color,
    this.fontWeight = FontWeight.normal,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontFamily,
  });

  // Regular text
  const CustomText.regular({
    super.key,
    required this.text,
    this.fontSize = AppConstants.fontMedium,
    this.color = AppColors.textPrimary,
    this.textAlign,
    this.maxLines,
    this.overflow,
  })  : fontWeight = FontWeight.normal,
        fontFamily = 'Regular';

  // Medium text
  const CustomText.medium({
    super.key,
    required this.text,
    this.fontSize = AppConstants.fontMedium,
    this.color = AppColors.textPrimary,
    this.textAlign,
    this.maxLines,
    this.overflow,
  })  : fontWeight = FontWeight.w500,
        fontFamily = 'Medium';

  // Bold text
  const CustomText.bold({
    super.key,
    required this.text,
    this.fontSize = AppConstants.fontMedium,
    this.color = AppColors.textPrimary,
    this.textAlign,
    this.maxLines,
    this.overflow,
  })  : fontWeight = FontWeight.bold,
        fontFamily = 'Bold';

  // Heading text
  const CustomText.heading({
    super.key,
    required this.text,
    this.fontSize = AppConstants.fontHeading,
    this.color = AppColors.textPrimary,
    this.textAlign,
    this.maxLines,
    this.overflow,
  })  : fontWeight = FontWeight.bold,
        fontFamily = 'Bold';

  // Title text
  const CustomText.title({
    super.key,
    required this.text,
    this.fontSize = AppConstants.fontTitle,
    this.color = AppColors.textPrimary,
    this.textAlign,
    this.maxLines,
    this.overflow,
  })  : fontWeight = FontWeight.bold,
        fontFamily = 'Bold';

  // Secondary text
  const CustomText.secondary({
    super.key,
    required this.text,
    this.fontSize = AppConstants.fontSmall,
    this.color = AppColors.textSecondary,
    this.textAlign,
    this.maxLines,
    this.overflow,
  })  : fontWeight = FontWeight.normal,
        fontFamily = 'Regular';

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontFamily: fontFamily ?? 'Regular',
        fontSize: fontSize ?? AppConstants.fontMedium,
        color: color ?? AppColors.textPrimary,
        fontWeight: fontWeight,
      ),
    );
  }
}
