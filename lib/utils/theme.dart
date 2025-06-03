import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vertex/utils/constants.dart';

// enum CurrentTheme { dark, light }

class UhlLinkTheme {
  UhlLinkTheme._();

  static final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      primaryColor: Constants.primaryLight,
      scaffoldBackgroundColor: Constants.scaffoldBackgroundColorLight,
      textTheme: TextTheme(
        titleLarge: TextStyle(
            color: Constants.textColorActiveLight,
            fontFamily: "Montserrat_Bold",
            fontSize: 36),
        titleMedium: TextStyle(
            color: Constants.textColorActiveLight,
            fontFamily: "Montserrat_Bold",
            fontSize: 28),
        labelSmall: TextStyle(
            color: Constants.textColorActiveLight,
            fontFamily: "Montserrat_Medium",
            fontSize: 15),
        bodyMedium: TextStyle(
            color: Constants.textColorActiveLight,
            fontFamily: "Montserrat_SemiBold",
            fontSize: 20),
        bodySmall: TextStyle(
            color: Constants.textColorActiveLight,
            fontFamily: "Montserrat_Regular",
            fontSize: 18),
      ),
      cardColor: Constants.cardLight,
      hoverColor: Constants.primaryLight,
      splashColor: Constants.scaffoldBackgroundColorLight,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: Constants.primaryLight,
        onPrimary: Colors.white,
        secondary: Constants.scaffoldBackgroundColorLight,
        onSecondary: Constants.cardLight,
        error: Constants.errorLight.withAlpha(100),
        onError: Constants.errorLight,
        surface: Constants.cardLight,
        onSurface: Constants.textColorActiveLight,
        scrim: Constants.textColorInactiveLight,
      ));

  static final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      primaryColor: Constants.primaryDark,
      scaffoldBackgroundColor: Constants.scaffoldBackgroundColorDark,
      textTheme: TextTheme(
        titleLarge: TextStyle(
            color: Constants.textColorActiveDark,
            fontFamily: "Montserrat_Bold",
            fontSize: 36),
        titleMedium: TextStyle(
            color: Constants.textColorActiveDark,
            fontFamily: "Montserrat_Bold",
            fontSize: 28),
        labelSmall: TextStyle(
            color: Constants.textColorActiveDark,
            fontFamily: "Montserrat_Medium",
            fontSize: 15),
        bodyMedium: TextStyle(
            color: Constants.textColorActiveDark,
            fontFamily: "Montserrat_SemiBold",
            fontSize: 20),
        bodySmall: TextStyle(
            color: Constants.textColorActiveDark,
            fontFamily: "Montserrat_Regular",
            fontSize: 18),
      ),
      cardColor: Constants.cardDark,
      hoverColor: Constants.primaryDark,
      splashColor: Constants.scaffoldBackgroundColorDark,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Constants.primaryDark,
        onPrimary: Colors.white,
        secondary: Constants.scaffoldBackgroundColorDark,
        onSecondary: Constants.cardDark,
        error: Constants.errorDark.withAlpha(100),
        onError: Constants.errorDark,
        surface: Constants.cardDark,
        onSurface: Constants.textColorActiveDark,
        scrim: Constants.textColorInactiveDark,
      ));
}

// Events
abstract class ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

class InitializeTheme extends ThemeEvent {}

// States
class ThemeState {
  final bool isDark;
  ThemeState({required this.isDark});
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final FlutterSecureStorage storage;

  ThemeBloc({required this.storage}) : super(ThemeState(isDark: false)) {
    on<ToggleTheme>((event, emit) async {
      final newIsDark = !state.isDark;
      await storage.write(key: 'isDark', value: newIsDark.toString());
      emit(ThemeState(isDark: newIsDark));
    });

    on<InitializeTheme>((event, emit) async {
      bool isDark = false;
      try {
        isDark = (await storage.read(key: 'isDark')) == "true" ? true : false;
      } catch (e) {
        await storage.deleteAll();
        isDark = false;
      }
      emit(ThemeState(isDark: isDark));
    });
  }

  void loadSavedTheme() {
    add(InitializeTheme());
  }
}
