import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dream/timer/app_config_bloc/app_config_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'language_select_dialog.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    String setting = AppLocalizations.of(context)!.setting;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          setting,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          buildColorItem(context),
          buildLocalItem(context),
        ],
      ),
    );
  }

  Widget buildColorItem(BuildContext context) {
    String colorThemeTitle = AppLocalizations.of(context)!.colorThemeTitle;
    String colorThemeSubTitle =
        AppLocalizations.of(context)!.colorThemeSubTitle;

    return ListTile(
      onTap: () => _selectColor(context),
      title: Text(colorThemeTitle),
      subtitle: Text(colorThemeSubTitle),
      trailing: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget buildLocalItem(BuildContext context) {
    String local =
        BlocProvider.of<AppConfigBloc>(context).state.locale.languageCode;

    String localTitle = AppLocalizations.of(context)!.localTitle;
    String localSubTitle = AppLocalizations.of(context)!.localSubTitle;

    return ListTile(
      onTap: () => changeLanguage(context),
      title: Text(localTitle),
      subtitle: Text(localSubTitle),
      trailing: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all()),
        child: Text(local, style: const TextStyle(height: 1)),
      ),
    );
  }

  void _selectColor(BuildContext context) async {
    Color initColor = Theme.of(context).primaryColor;
    final Color newColor = await showColorPickerDialog(
      context,
      initColor,
      title: Text('选择颜色', style: Theme.of(context).textTheme.titleLarge),
      width: 40,
      height: 40,
      spacing: 0,
      runSpacing: 0,
      borderRadius: 0,
      wheelDiameter: 165,
      enableOpacity: true,
      showColorCode: true,
      colorCodeHasColor: true,
      pickersEnabled: <ColorPickerType, bool>{ColorPickerType.wheel: true},
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        copyButton: false,
        pasteButton: false,
        longPressMenu: true,
      ),
      actionButtons: const ColorPickerActionButtons(
        okButton: true,
        closeButton: true,
        dialogActionButtons: false,
      ),
      constraints: const BoxConstraints(
        minHeight: 480,
        minWidth: 320,
        maxWidth: 320,
      ),
    );

    BlocProvider.of<AppConfigBloc>(context).switchThemeColor(newColor);
  }

  void changeLanguage(BuildContext context) {
    showLanguageSelectDialog(context);
  }
}
