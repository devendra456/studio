import 'package:flutter/material.dart';
import 'package:studio/application/core/di.dart';
import 'package:studio/application/preferences/app_preferences.dart';
import 'package:studio/application/preferences/app_preferences_keys.dart';

import '../../application/constants.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late bool blur;
  late bool greyScale;
  late bool square;
  int? height;
  int? width;
  double blurValue = 1.0;

  @override
  void initState() {
    super.initState();
    loadPreviousData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          CheckboxListTile(
            value: blur,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            onChanged: onBlurChange,
            title: const Text("Blur"),
          ),
          if (blur == true)
            Slider(
              value: blurValue,
              onChanged: onBlurSliderChange,
              min: 1,
              max: 10,
            ),
          CheckboxListTile(
            value: greyScale,
            onChanged: onGreyScaleChange,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: const Text("Greyscale"),
          ),
          CheckboxListTile(
            value: square,
            onChanged: onSquareChange,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: const Text("Square"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Width",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          isDense: true,
                          border: const OutlineInputBorder(),
                          hintText: "${width ?? "$kInitialWidth"}",
                        ),
                        onSubmitted: (value) {
                          final val = int.tryParse(value) ?? kInitialWidth;
                          if (val <= 5000) {
                            width = val;
                            if (square) {
                              height = val;
                            }
                            setState(() {});
                          }
                        },
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 32,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Height",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextField(
                        readOnly: square,
                        decoration: InputDecoration(
                          isDense: true,
                          border: const OutlineInputBorder(),
                          hintText: "${height ?? "$kInitialWidth"}",
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          final val = int.tryParse(value) ?? kInitialWidth;
                          if (val <= 5000) {
                            height = val;
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void onBlurChange(bool? value) {
    blur = value ?? false;
    setState(() {});
  }

  void onGreyScaleChange(bool? value) {
    greyScale = value ?? false;
    setState(() {});
  }

  void onSquareChange(bool? value) {
    square = value ?? false;
    height = width;
    setState(() {});
  }

  void loadPreviousData() {
    final AppPreferences preferences = getIt.get<AppPreferences>();
    greyScale = preferences.getBool(AppPreferencesKeys.grayScale) ?? false;
    final b = preferences.getDouble(AppPreferencesKeys.blur);
    if (b != null && b != 0) {
      blur = true;
      blurValue = b;
    } else {
      blur = false;
    }
    height = preferences.getInt(AppPreferencesKeys.height);
    width = preferences.getInt(AppPreferencesKeys.width);
    if (height != null && width != null && height == width) {
      square = true;
    } else {
      square = false;
    }
    setState(() {});
  }

  void onBlurSliderChange(double value) {
    blurValue = value;
    setState(() {});
  }

  @override
  void dispose() {
    setValues();
    super.dispose();
  }

  void setValues() {
    final AppPreferences preferences = getIt.get<AppPreferences>();
    preferences.setBool(AppPreferencesKeys.grayScale, greyScale);
    if (blur) {
      preferences.setDouble(AppPreferencesKeys.blur, blurValue);
    } else {
      preferences.setDouble(AppPreferencesKeys.blur, 0);
    }
    preferences.setInt(AppPreferencesKeys.height, height ?? kInitialHeight);
    preferences.setInt(AppPreferencesKeys.width, width ?? kInitialWidth);
  }
}
