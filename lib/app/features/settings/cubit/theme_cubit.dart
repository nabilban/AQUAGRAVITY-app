import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

@injectable
class ThemeCubit extends Cubit<ThemeState> {
  static const _themeKey = 'theme_mode';

  ThemeCubit() : super(const ThemeState()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_themeKey);
    if (index != null && index >= 0 && index < ThemeMode.values.length) {
      emit(state.copyWith(themeMode: ThemeMode.values[index]));
    }
  }

  Future<void> updateTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
    emit(state.copyWith(themeMode: mode));
  }
}
