import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dream/timer/app_config_bloc/app_config.dart';

class AppConfigBloc extends Cubit<AppConfig> {
  AppConfigBloc({required AppConfig appConfig}) : super(appConfig);

  void switchThemeColor(Color color) {
    if (color != state.themeColor) {
      emit(state.copyWith(color: color));
    }
  }

  void switchLanguage(Locale? locale) {
    if (locale != state.locale) {
      emit(state.copyWith(locale: locale));
    }
  }
}
