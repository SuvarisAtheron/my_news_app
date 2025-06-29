    // lib/shared/widgets/custom_form_field.dart
    import 'package:flutter/material.dart';
    import 'package:my_news_app/shared/styles/app_styles.dart';

    class CustomFormField extends StatelessWidget {
      final TextEditingController? controller;
      final bool obscureText;
      final String hintText;
      final String? labelText; // <<< TAMBAHKAN INI
      final Widget? suffixIcon;
      final TextInputType? keyboardType;
      final TextInputAction? textInputAction;
      final String? Function(String?)? validator;
      final int? maxLines;
      final bool readOnly;
      final void Function(String)? onChanged;
      final void Function()? onTap;

      const CustomFormField({
        super.key,
        this.controller,
        this.obscureText = false,
        required this.hintText,
        this.labelText, // <<< TAMBAHKAN INI DI KONSTRUKTOR
        this.suffixIcon,
        this.keyboardType,
        this.textInputAction,
        this.validator,
        this.maxLines = 1,
        this.readOnly = false,
        this.onChanged,
        this.onTap,
      });

      @override
      Widget build(BuildContext context) {
        return TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          maxLines: maxLines,
          readOnly: readOnly,
          onChanged: onChanged,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText, // <<< GUNAKAN INI
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius),
              borderSide: BorderSide(color: kGreyColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius),
              borderSide: BorderSide(color: kLightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius),
              borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
            ),
            fillColor: kWhiteColor,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
          ),
          style: kBodyTextStyle,
        );
      }
    }
    