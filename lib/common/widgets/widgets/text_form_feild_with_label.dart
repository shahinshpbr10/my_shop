import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';

class TextFormFieldWithLabel extends StatelessWidget {
  const TextFormFieldWithLabel({
    super.key,
    required TextEditingController controller,
    required this.hintText,
    required this.labelText,
    required this.iconData,
  }) : _email = controller;

  final TextEditingController _email;
  final String? hintText;
  final String? labelText;
  final IconData? iconData;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText!,
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: _email,
          validator: (text) {
            if (text == null || text.isEmpty) {
              return 'Email is empty';
            }
            return null;
          },
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: TColors.buttonPrimary),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              hintText: hintText,
              prefixIcon: Icon(iconData, color: TColors.light),
              // hintStyle: AppTextStyle.buttonText,
              // hoverColor: AppColors.buttonColor,
              // fillColor: AppColors.buttonColor,
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  width: 3,
                  // color: AppColors.buttonColor, // Border color when focused
                ),
              ),
              filled: true),
        )
      ],
    );
  }
}
