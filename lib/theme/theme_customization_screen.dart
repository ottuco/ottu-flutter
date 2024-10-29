import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart' as ch;
import 'package:ottu_flutter_checkout_sample/theme/theme_customization_screen_cubit.dart';
import 'package:ottu_flutter_checkout_sample/theme/theme_customization_state.dart';

class ThemeCustomizationScreen extends StatefulWidget {
  const ThemeCustomizationScreen({super.key});

  @override
  State<ThemeCustomizationScreen> createState() => _ThemeCustomizationScreenState();
}

class _ThemeCustomizationScreenState extends State<ThemeCustomizationScreen> {
  final amountEditingController = TextEditingController();

  final uiModeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Customize your Theme'),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: BlocBuilder<ThemeCustomizationScreenCubit, ThemeCustomizationState>(
                        builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DropdownMenu<ch.CustomerUiMode>(
                            initialSelection: ch.CustomerUiMode.auto,
                            controller: uiModeController,
                            requestFocusOnTap: true,
                            label: const Text('Ui Mode'),
                            onSelected: (ch.CustomerUiMode? mode) {
                              final newTheme =
                                  (state.theme ?? ch.CheckoutTheme()).copyWith(uiMode: mode);
                              context
                                  .read<ThemeCustomizationScreenCubit>()
                                  .onThemeChanged(newTheme);
                            },
                            dropdownMenuEntries: ch.CustomerUiMode.values
                                .map<DropdownMenuEntry<ch.CustomerUiMode>>(
                                    (ch.CustomerUiMode mode) {
                              return DropdownMenuEntry<ch.CustomerUiMode>(
                                value: mode,
                                label: mode.name,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),
                          _colorOptionItem(state.theme?.sdkBackgroundColor?.color, "SDK background",
                              (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme())
                                .copyWith(sdkBackgroundColor: ch.ColorState(color: color));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: 2),
                          const Divider(
                              height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0),
                          const SizedBox(height: 2),
                          _colorOptionItem(
                              state.theme?.modalBackgroundColor?.color, "Modal background",
                              (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme())
                                .copyWith(modalBackgroundColor: ch.ColorState(color: color));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: 2),
                          const Divider(
                              height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0),
                          const SizedBox(height: 8),
                          _colorOptionItem(
                              state.theme?.mainTitleText?.textColor?.color, "Main title", (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme()).copyWith(
                                mainTitleText:
                                    ch.TextStyle(textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: 2),
                          const Divider(
                              height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0),
                          const SizedBox(height: 2),
                          _colorOptionItem(state.theme?.titleText?.textColor?.color, "Title",
                              (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme()).copyWith(
                                titleText: ch.TextStyle(textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: 2),
                          const Divider(
                              height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0),
                          const SizedBox(height: 2),
                          _colorOptionItem(state.theme?.subtitleText?.textColor?.color, "Subtitle",
                              (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme()).copyWith(
                                subtitleText: ch.TextStyle(textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: 2),
                          const Divider(
                              height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0),
                          const SizedBox(height: 2),
                          _colorOptionItem(
                              state.theme?.feesTitleText?.textColor?.color, "Fees Title", (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme()).copyWith(
                                feesTitleText:
                                    ch.TextStyle(textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: 2),
                          const Divider(
                              height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0),
                          const SizedBox(height: 2),
                          _colorOptionItem(
                              state.theme?.feesSubtitleText?.textColor?.color, "Fees Subtitle",
                              (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme()).copyWith(
                                feesSubtitleText:
                                    ch.TextStyle(textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: 2),
                          const Divider(
                              height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0),
                          const SizedBox(height: 2),
                          _colorOptionItem(
                              state.theme?.dataLabelText?.textColor?.color, "Data label", (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme()).copyWith(
                                dataLabelText:
                                    ch.TextStyle(textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: 2),
                          const Divider(
                              height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0),
                          const SizedBox(height: 2),
                          _colorOptionItem(
                              state.theme?.dataValueText?.textColor?.color, "Data value", (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme()).copyWith(
                                dataValueText:
                                    ch.TextStyle(textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: 2),
                          const Divider(
                              height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0),
                          const SizedBox(height: 2),
                          _colorOptionItem(
                              state.theme?.errorMessageText?.textColor?.color, "Error message",
                              (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme()).copyWith(
                                errorMessageText:
                                    ch.TextStyle(textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: 2),
                          const Divider(
                              height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0),
                          const SizedBox(height: 2),
                          _colorOptionItem(
                              state.theme?.inputTextField?.text?.textColor?.color, "Input field",
                              (color) {
                            /* final newTheme = state.theme.copyWith(
                                inputTextField: ch.TextFieldStyle(text: textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);*/
                          }),
                          const SizedBox(height: 2),
                          const Divider(
                              height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0),
                          const SizedBox(height: 2),
                          _colorOptionItem(
                              state.theme?.inputTextField?.text?.textColor?.color, "Button",
                              (color) {
                            /* final newTheme = state.theme.copyWith(
                                inputTextField: ch.TextFieldStyle(text: textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);*/
                          }),
                          const SizedBox(height: 2),
                          const Divider(
                              height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0),
                          const SizedBox(height: 2),
                          _colorOptionItem(state.theme?.inputTextField?.text?.textColor?.color,
                              "Selector Button", (color) {
                            /* final newTheme = state.theme.copyWith(
                                inputTextField: ch.TextFieldStyle(text: textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);*/
                          }),
                          const SizedBox(height: 2),
                          const Divider(
                              height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0),
                          const SizedBox(height: 2),
                          _colorOptionItem(
                              state.theme?.inputTextField?.text?.textColor?.color, "Switch",
                              (color) {
                            /* final newTheme = state.theme.copyWith(
                                inputTextField: ch.TextFieldStyle(text: textColor: ch.ColorState(color: color)));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);*/
                          }),
                          const SizedBox(height: 2),
                          const Divider(
                              height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0),
                          const SizedBox(height: 2),
                          _colorOptionItem(state.theme?.savePhoneNumberIconColor?.color,
                              "Save Phone Number Icon Color", (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme())
                                .copyWith(savePhoneNumberIconColor: ch.ColorState(color: color));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: 2),
                          const Divider(
                              height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0),
                          const SizedBox(height: 2),
                          _colorOptionItem(
                              state.theme?.selectorIconColor?.color, "Select Payment Icon Color",
                              (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme())
                                .copyWith(selectorIconColor: ch.ColorState(color: color));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                          const SizedBox(height: 2),
                          const Divider(
                              height: 1, thickness: 1, color: Colors.lightBlueAccent, endIndent: 0),
                          const SizedBox(height: 2),
                          _colorOptionItem(state.theme?.paymentItemBackgroundColor?.color,
                              "Select Payment Background Color", (color) {
                            final newTheme = (state.theme ?? ch.CheckoutTheme())
                                .copyWith(paymentItemBackgroundColor: ch.ColorState(color: color));
                            context.read<ThemeCustomizationScreenCubit>().onThemeChanged(newTheme);
                          }),
                        ],
                      );
                    }))),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
                style: ButtonStyle(backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.lightBlueAccent;
                    }
                    return Colors.amber; // Use the component's default.
                  },
                )),
                onPressed: () {
                  context.read<ThemeCustomizationScreenCubit>().onSave();
                },
                child: const Text("Save")),
          ),
        ]));
  }

  InkWell _colorOptionItem(Color? colorStyle, String title, Function(Color color) onColorChange) {
    final color = colorStyle ?? Colors.grey;
    final isEmpty = colorStyle == null;
    return InkWell(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(1.0)),
          ),
          child: isEmpty ? CustomPaint(painter: CrossingLinesPainter()) : const SizedBox.shrink(),
        ),
      ]),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return pickerDialog(color, onColorChange);
          },
        );
      },
    );
  }

  Widget pickerDialog(Color initialColor, Function(Color color) onColorChanged) {
    Color localColor = initialColor;
    return AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: initialColor,
          onColorChanged: (color) {
            localColor = color;
          },
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Apply'),
          onPressed: () {
            Navigator.of(context).pop();
            onColorChanged(localColor);
          },
        ),
      ],
    );
  }
}

class CrossingLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const p0_0 = Offset(0, 0);
    final p1_1 = Offset(size.width, size.height);
    final p1_0 = Offset(size.width, 0);
    final p0_1 = Offset(0, size.height);
    final paint = Paint()
      ..color = Colors.black.withAlpha(100)
      ..strokeWidth = 1;
    canvas.drawLine(p0_0, p1_1, paint);
    canvas.drawLine(p1_0, p0_1, paint);
  }

  @override
  bool shouldRepaint(CrossingLinesPainter oldDelegate) => false;
}
