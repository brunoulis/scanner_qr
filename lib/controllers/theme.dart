  
  import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    extensions: <ThemeExtension<CustomColors>>[
      CustomColors.light,
    ],
  );
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    extensions: <ThemeExtension<CustomColors>>[
      CustomColors.dark,
    ],
  );
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? customOne;
  final Color? customTwo;

  const CustomColors({
    this.customOne,
    this.customTwo,
  });
  @override
  ThemeExtension<CustomColors> copyWith ({
    Color? customOne,
    Color? customTwo,
  }) {
    return CustomColors(
      customOne: customOne ?? this.customOne,
      customTwo: customTwo ?? this.customTwo,
    );
  }
  
  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if(other is! CustomColors){
      return this;
    }
    return CustomColors(
      customOne: Color.lerp(customOne, other.customOne, t),
      customTwo: Color.lerp(customTwo, other.customTwo, t),
    );
  }
  static const light = CustomColors(
    customOne: Color.fromARGB(255, 255, 17, 0),
    customTwo: Color.fromARGB(255, 0, 115, 255),
  );
  static const dark = CustomColors(
    customOne: Color.fromARGB(255, 0, 255, 55),
    customTwo: Color.fromARGB(255, 38, 0, 255),
  );
}
	