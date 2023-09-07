import 'package:flutter/material.dart';
import 'package:studio/application/core/di.dart';
import 'package:studio/application/core/show_message.dart';
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

  // int? height;
  // int? width;
  double blurValue = 1.0;
  late final TextEditingController _heightController;
  late final TextEditingController _widthController;

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
            title: Text(
              "Blur",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (blur == true)
            Slider(
              value: blurValue,
              onChanged: onBlurSliderChange,
              min: 1,
              max: 9,
            ),
          CheckboxListTile(
            value: greyScale,
            onChanged: onGreyScaleChange,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              "Greyscale",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          CheckboxListTile(
            value: square,
            onChanged: onSquareChange,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              "Square",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
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
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextField(
                        controller: _widthController,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          hintText: "width",
                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                        ),
                        textInputAction: TextInputAction.next,
                        style: Theme.of(context).textTheme.bodyMedium,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final width = int.tryParse(value) ?? kInitialWidth;
                          if (width > 5000) {
                            ShowMessage.show(context,
                                "width is too much! Enter less than 5000");
                            _widthController.text = kInitialWidth.toString();
                          }
                          if (square) {
                            _heightController.text = value;
                          }
                        },
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
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      TextField(
                        controller: _heightController,
                        readOnly: square,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          hintText: "height",
                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (value) {
                          final height = int.tryParse(value) ?? kInitialHeight;
                          if (height > 5000) {
                            ShowMessage.show(context,
                                "height is too much! Enter less than 5000");
                            _heightController.text = kInitialHeight.toString();
                          }
                        },
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
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
    _heightController.text = _widthController.text;
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
    int? height = preferences.getInt(AppPreferencesKeys.height);
    int? width = preferences.getInt(AppPreferencesKeys.width);
    _heightController = TextEditingController(text: height?.toString());
    _widthController = TextEditingController(text: width?.toString());
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
    preferences.setInt(AppPreferencesKeys.height,
        int.tryParse(_heightController.text) ?? kInitialHeight);
    preferences.setInt(AppPreferencesKeys.width,
        int.tryParse(_widthController.text) ?? kInitialWidth);
  }
}
