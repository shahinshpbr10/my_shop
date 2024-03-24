import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';


class TcheckBox {
  TcheckBox._();

  static CheckboxThemeData lightCheckBox = CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      checkColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        } else {
          return Colors.black;
        }
      }),
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return TColors.primary;
        } else {
          return Colors.transparent;
        }
      }));

  static CheckboxThemeData darkCheckBox = CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      checkColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        } else {
          return Colors.black;
        }
      }),
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return TColors.primary;
        } else {
          return Colors.transparent;
        }
      }));
}
