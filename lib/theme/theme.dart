import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/theme/custom_theme/appbartheame.dart';
import 'package:my_shop/theme/custom_theme/bottomsheetTheme.dart';
import 'package:my_shop/theme/custom_theme/checkboxtheme.dart';
import 'package:my_shop/theme/custom_theme/chip_theme.dart';
import 'package:my_shop/theme/custom_theme/elevatedbutoontheme.dart';
import 'package:my_shop/theme/custom_theme/outlineButton_theme.dart';
import 'package:my_shop/theme/custom_theme/text_theme.dart';
import 'package:my_shop/theme/custom_theme/textfieldTheme.dart';


class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.light,
      primaryColor: TColors.primary,
      scaffoldBackgroundColor: Colors.white,
      textTheme: AppTextTheme.lightTextTheme,
      appBarTheme: TAppBarThemes.lightAppbarTheme,
      checkboxTheme: TcheckBox.lightCheckBox,
      elevatedButtonTheme: AppElevetedButtonTheme.lightElevatedButtonTheme,
      bottomSheetTheme: TBottomSheetTheme.lightBottomSheet,
      chipTheme: TchipTheme.lightChipTheme,
      outlinedButtonTheme: ToutLineButtonTheme.lightOutlineButton,
      inputDecorationTheme: TtextFormFieldTheme.lightInputDecorationTheme);

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: TColors.primary,
      scaffoldBackgroundColor: Colors.black,
      textTheme: AppTextTheme.darkTextTheme,
      appBarTheme: TAppBarThemes.darkAppbarTheme,
      checkboxTheme: TcheckBox.darkCheckBox,
      elevatedButtonTheme: AppElevetedButtonTheme.darkElevatedButtonTheme,
      bottomSheetTheme: TBottomSheetTheme.darkBottomSheet,
      chipTheme: TchipTheme.darkChipTheme,
      outlinedButtonTheme: ToutLineButtonTheme.darkOutlineButton,
      inputDecorationTheme: TtextFormFieldTheme.darkInputDecorationTheme);
}
