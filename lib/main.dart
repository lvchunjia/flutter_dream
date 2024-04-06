import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dream/storage/db_storage/db_storage.dart';
import 'package:flutter_dream/timer/app_config_bloc/app_config.dart';
import 'package:flutter_dream/timer/app_config_bloc/app_config_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'navigation/app_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbStorage.instance.open();
  runApp(BlocProvider(
    create: (_) => AppConfigBloc(appConfig: AppConfig.defaultConfig()),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle overlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    );

    return BlocBuilder<AppConfigBloc, AppConfig>(
      builder: (_, state) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: state.locale, // 指定语言
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: state.themeColor,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: overlayStyle,
          ),
          useMaterial3: true,
        ),

        home: const AppNavigation(),
      ),
    );
  }
}
