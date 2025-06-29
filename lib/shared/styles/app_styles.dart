// lib/shared/styles/app_styles.dart

import 'package:flutter/material.dart';

// --- Colors ---
const Color kPrimaryColor = Color(0xFF2196F3); // Biru terang (Anda bisa ubah)
const Color kSecondaryColor = Color(0xFF4CAF50); // Hijau (Anda bisa ubah)
const Color kAccentColor = Color(0xFFFFC107); // Kuning (Anda bisa ubah)
const Color kRedColor = Color(0xFFF44336);
const Color kGreenColor = Color(0xFF4CAF50);
const Color kGreyColor = Color(0xFF9E9E9E);
const Color kBlackColor = Color(0xFF212121);
const Color kWhiteColor = Color(0xFFFFFFFF);
const Color kLightGrey = Color(0xFFEEEEEE);
const Color kDarkGrey = Color(0xFF616161);

// --- Gradients (Contoh Sederhana) ---
const LinearGradient kPrimaryGradientColor = LinearGradient(
  colors: [kPrimaryColor, Color(0xFF64B5F6)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const LinearGradient kSecondaryGradientColor = LinearGradient(
  colors: [kSecondaryColor, Color(0xFF81C784)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// --- Spacings ---
const double kDefaultPadding = 16.0;
const double kDefaultMargin = 16.0;
const double kDefaultBorderRadius = 8.0;

// --- Box Shadow (Contoh Sederhana) ---
const List<BoxShadow> kDefaultBoxShadow = [
  BoxShadow(
    color: Colors.black12,
    offset: Offset(0, 2),
    blurRadius: 4,
    spreadRadius: 0,
  ),
];

// --- Font Sizes ---
const double kSmallText = 12.0;
const double kMediumText = 16.0;
const double kLargeText = 20.0;
const double kExtraLargeText = 24.0;

// --- Text Styles ---
const TextStyle kHeadlineTextStyle = TextStyle(
  fontSize: kExtraLargeText,
  fontWeight: FontWeight.bold,
  color: kBlackColor,
);

const TextStyle kTitleTextStyle = TextStyle(
  fontSize: kLargeText,
  fontWeight: FontWeight.bold,
  color: kBlackColor,
);

const TextStyle kSubtitleTextStyle = TextStyle(
  fontSize: kMediumText,
  fontWeight: FontWeight.w600,
  color: kDarkGrey,
);

const TextStyle kBodyTextStyle = TextStyle(
  fontSize: kMediumText,
  color: kBlackColor,
);

const TextStyle kSmallBodyTextStyle = TextStyle(
  fontSize: kSmallText,
  color: kGreyColor,
);